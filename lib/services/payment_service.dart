import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_success_dialog.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaymentService {
  static final TeacherRepository _teacherRepo = Get.find<TeacherRepository>();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CourseRepository _courseRepo = CourseRepository();

  static const String _accessKey = 'F8BBA842ECF85';
  static const String _secretKey = 'K951B6PE1waDMi640xX08PD3vg6EkVlz';
  static const String _partnerCode = 'MOMO';
  static const String _createEndpoint =
      'https://test-payment.momo.vn/v2/gateway/api/create';
  static const String _queryEndpoint =
      'https://test-payment.momo.vn/v2/gateway/api/query';

  static Future<void> processPayment({
    required String courseId,
    required double amount,
    required BuildContext context,
  }) async {
    //Hiển thị Loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final String requestId = const Uuid().v4();
      final String orderId =
          "${_partnerCode}${DateTime.now().millisecondsSinceEpoch}";
      final String orderInfo = "Thanh toan khoa hoc $courseId";
      final String amountStr = amount.toInt().toString();
      final String redirectUrl =
          "https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b";
      final String ipnUrl =
          "https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b";

      const String requestType = "payWithMethod";
      const String extraData = "";

      final String rawSignature =
          "accessKey=$_accessKey&amount=$amountStr&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$_partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType";

      final hmacSha256 = Hmac(sha256, utf8.encode(_secretKey));
      final digest = hmacSha256.convert(utf8.encode(rawSignature));
      final String signature = digest.toString();

      // GỌI API MOMO
      print("-------------------- GỬI REQUEST MOMO (CREATE) ----------------");
      final response = await http.post(
        Uri.parse(_createEndpoint),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'partnerCode': _partnerCode,
          'partnerName': "Test App",
          'storeId': "MomoTestStore",
          'requestId': requestId,
          'amount': amountStr,
          'orderId': orderId,
          'orderInfo': orderInfo,
          'redirectUrl': redirectUrl,
          'ipnUrl': ipnUrl,
          'lang': 'vi',
          'requestType': requestType,
          'autoCapture': true,
          'extraData': extraData,
          'signature': signature,
        }),
      );

      print("MoMo Create Status: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception("Lỗi kết nối MoMo: ${response.statusCode}");
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['resultCode'] != 0) {
        throw Exception("Lỗi từ MoMo: ${jsonResponse['message']}");
      }

      // LẤY PAY URL
      final String payUrl = jsonResponse['payUrl'];
      print("👉 Đã lấy được Link thanh toán: $payUrl");

      Get.back(); // Tắt dialog loading khởi tạo

      // MỞ WEBVIEW
      final result = await Get.to(
        () => PaymentWebViewScreen(paymentUrl: payUrl, returnUrl: redirectUrl),
      );

      // KIỂM TRA LẠI TRẠNG THÁI
      bool isSuccess = result == true;

      // Nếu WebView trả về false (người dùng đóng hoặc chưa redirect kịp)
      //gọi API checkTransactionStatus để hỏi lại
      if (!isSuccess) {
        print(
          "⚠️ WebView đóng nhưng chưa xác nhận thành công. Đang kiểm tra lại với Server MoMo...",
        );

        // Hiện lại loading để check
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        isSuccess = await _checkTransactionStatus(orderId, requestId);

        Get.back(); // Tắt loading check
      }

      if (isSuccess) {
        print("Giao dịch THÀNH CÔNG (Đã xác thực)");

        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        try {
          final studentId = context.read<AuthBloc>().state.userModel?.uid;
          if (studentId == null) throw Exception("User not found");

          await _courseRepo.enrollInCourse(
            courseId,
            studentId,
            isPremium: true,
          );

          final courseDoc = await _firestore
              .collection('courses')
              .doc(courseId)
              .get();
          final teacherId = courseDoc.data()?['instructorId'] as String?;

          if (teacherId != null && teacherId.isNotEmpty) {
            await _teacherRepo.addDeposit(
              teacherId: teacherId,
              amount: amount,
              studentId: studentId,
              courseId: courseId,
            );
          }

          Get.back(); // Tắt loading ghi danh
          Get.dialog(const PaymentSuccessDialog(), barrierDismissible: false);
        } catch (e) {
          Get.back();
          Get.snackbar(
            'Lỗi',
            'Thanh toán thành công nhưng lỗi ghi danh: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print("❌ Giao dịch THẤT BẠI hoặc CHƯA THANH TOÁN");
        Get.snackbar(
          'Thông báo',
          'Giao dịch chưa hoàn tất hoặc bị hủy.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Đảm bảo tắt dialog nếu có lỗi
      if (Get.isDialogOpen ?? false) Get.back();

      print("Error processing payment: $e");
      Get.snackbar(
        'Lỗi thanh toán',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<bool> _checkTransactionStatus(
    String orderId,
    String requestId,
  ) async {
    try {
      final rawSignature =
          "accessKey=$_accessKey&orderId=$orderId&partnerCode=$_partnerCode&requestId=$requestId";

      final hmacSha256 = Hmac(sha256, utf8.encode(_secretKey));
      final digest = hmacSha256.convert(utf8.encode(rawSignature));
      final signature = digest.toString();

      final response = await http.post(
        Uri.parse(_queryEndpoint),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'partnerCode': _partnerCode,
          'requestId': requestId,
          'orderId': orderId,
          'signature': signature,
          'lang': 'vi',
        }),
      );

      print("Query Status Code: ${response.statusCode}");
      print("Query Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['resultCode'] == 0) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Lỗi khi check trạng thái: $e");
      return false;
    }
  }
}
