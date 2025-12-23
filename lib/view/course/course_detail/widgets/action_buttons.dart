import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/certificate/certificate_preview_screen.dart';
import 'package:elearning_app/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CoursesLoaded && state.isSelectedCourseCompleted == true) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => CertificatePreviewScreen(course: course));
                  },
                  icon: const Icon(Icons.workspace_premium),
                  label: const Text('Xem chứng chỉ'),
                ),
              ),
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
          );
        }
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
                      AppRoutes.lesson.replaceAll(
                        'id',
                        course.lessons.first.id,
                      ),
                      parameters: {'courseId': course.id},
                    );
                  }
                },
                label: const Text('Bắt đầu học'),
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
      },
    );
  }
}
