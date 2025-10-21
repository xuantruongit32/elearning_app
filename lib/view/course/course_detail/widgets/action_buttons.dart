import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButtons extends StatelessWidget {
  final Course course;
  final isUnlocked;
  const ActionButtons({
    super.key,
    required this.course,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (course.isPremium && !isUnlocked) {
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
        if (!course.isPremium || isUnlocked) ...[
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => Get.to(
              () => ChatScreen(
                courseId: course.id,
                instructorId: course.instructorId,
                isTeacherView: false,
              ),
            ),
            icon: const Icon(Icons.chat),
          ),
        ],
      ],
    );
  }
}
