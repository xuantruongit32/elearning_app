import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_success_dialog.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class PaymentService {
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

    Get.back();
    final result = await Get.to(
      () => PaymentWebViewScreen(paymentUrl: paymentUrl, returnUrl: returnUrl),
    );

    if (result == true) {
      //payment success
      DummyDataService.addPurchasedCourse(courseId);
      Get.dialog(const PaymentSuccessDialog(), barrierDismissible: false);
    } else {
      //payment failed
      Get.snackbar(
        'Lỗi thanh toán',
        'Giao dịch không thành công, vui lòng thử lại.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
