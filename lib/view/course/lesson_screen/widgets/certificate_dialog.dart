import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/view/certificate/certificate_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateDialog extends StatelessWidget {
  final Course course;

  const CertificateDialog({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.workspace_premium,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'You have completed all lessons in "${course.title}"',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Now, you can download your certificate"',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Later',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  //navigate to certificate preview screen
                  Get.to(() => CertificatePreviewScreen(course: course));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'View Certificate',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
