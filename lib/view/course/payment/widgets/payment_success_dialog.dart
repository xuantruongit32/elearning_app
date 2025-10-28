import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            Text(
              'Thanh toán thành công!',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn có thể truy cập khoá học ngay.',
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: CustomButton(
                text: 'Bắt đầu học',
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
