import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
// import 'package:elearning_app/services/dummy_data_service.dart'; // <-- Bạn có thể xóa dòng này
import 'package:elearning_app/view/course/payment/widgets/payment_success_dialog.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class PaymentService {
  static final TeacherRepository _teacherRepo = Get.find<TeacherRepository>();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CourseRepository _courseRepo = CourseRepository();

  static Future<void> processPayment({
    required String courseId,
    required double amount,
    required BuildContext context,
  }) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    const String tmnCode = 'O8IIAIMF';
    const String hashSecret = '0P9JBK931ZJIO7G5EP21QZ43S8U4DQJZ';
    const String returnUrl = 'https://qldtbeta.phenikaa-uni.edu.vn';

    final DateTime createDate = DateTime.now();
    final DateTime expireDate = createDate.add(const Duration(minutes: 15));

    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
      version: '2.0.1',
      tmnCode: tmnCode,
      txnRef: createDate.millisecondsSinceEpoch.toString(),
      orderInfo: 'Thanh toan khoa hoc $courseId',
      amount: amount,
      returnUrl: returnUrl,
      ipAdress: '127.0.0.1',
      vnpayHashKey: hashSecret,
      vnPayHashType: VNPayHashType.HMACSHA512,
      vnpayExpireDate: expireDate,
    );

    Get.back(); // Tắt dialog loading của VNPAY
    final result = await Get.to(
      () => PaymentWebViewScreen(paymentUrl: paymentUrl, returnUrl: returnUrl),
    );

    if (result == true) {
      //Hiển thị dialog loading trong khi lưu vào Firebase
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        final studentId = context.read<AuthBloc>().state.userModel?.uid;

        if (studentId == null) {
          throw Exception("Không tìm thấy người dùng. Vui lòng đăng nhập lại.");
        }

        //GHI DANH người dùng vào khóa học
        await _courseRepo.enrollInCourse(courseId, studentId, isPremium: true);

        //Cộng tiền cho giáo viên
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
        } else {
          debugPrint(
            'Payment Success: Could not find teacherId for course $courseId',
          );
        }

        Get.back(); // Tắt dialog loading
        Get.dialog(const PaymentSuccessDialog(), barrierDismissible: false);
      } catch (e) {
        Get.back(); // Tắt dialog loading
        Get.snackbar(
          'Lỗi sau khi thanh toán',
          'Thanh toán thành công nhưng có lỗi khi ghi danh: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Lỗi thanh toán',
        'Giao dịch không thành công, vui lòng thử lại.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
