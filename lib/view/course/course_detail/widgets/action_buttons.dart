import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButtons extends StatelessWidget {
  final Course course;
  const ActionButtons({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (course.isPremium &&
                  !DummyDataService.isCourseUnlocked(course.id)) {
                // payment if is premium
                Get.toNamed(
                  AppRoutes.payment,
                  arguments: {
                    'courseId': course.id,
                    'courseName': course.title,
                    'price': course.price,
                  },
                );
              } else {
                // first lesson if free
                Get.toNamed(
                  AppRoutes.lesson.replaceAll('id', course.lessons.first.id),
                  parameters: {'courseId': course.id},
                );
              }
            },
            label: const Text('Start Learning'),
            icon: const Icon(Icons.play_circle),
          ),
        ),
        //show chat button if not premium or unlocked
        if (!course.isPremium ||
            DummyDataService.isCourseUnlocked(course.id)) ...[
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              // navigate to chat screen
            },
            icon: const Icon(Icons.chat),
          ),
        ],
      ],
    );
  }
}
