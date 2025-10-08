import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem page;
  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image
            Container(
              height: Get.height * 0.4,
              padding: const EdgeInsets.all(32),
              child: Image.asset(page.image, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
