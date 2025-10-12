import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/course/payment/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentService {
  static void processPayment({
    required GlobalKey<FormState> formKey,
    required String courseId,
  }) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    //payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); //close loading dialog

      // add the course to purchased courses
      DummyDataService.addPurchasedCourse(courseId);

      Get.dialog(const PaymentSuccessDialog(), barrierDismissible: false);
    });
  }
}
