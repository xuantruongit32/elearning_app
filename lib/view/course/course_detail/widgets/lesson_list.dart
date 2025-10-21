import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/course/course_detail/widgets/lesson_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonList extends StatefulWidget {
  final String courseId;
  final bool isUnlocked;
  final VoidCallback? onLessonComplete;
  const LessonList({
    super.key,
    required this.courseId,
    required this.isUnlocked,
    this.onLessonComplete,
  });

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  final CourseRepository _courseRepository = CourseRepository();
  Course? _course;
  bool _isLoading = true;
  Set<String> _completedLessons = {};

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    try {
      final course = await _courseRepository.getCourseDetail(widget.courseId);
      final completedLessons = await _courseRepository.getCompletedLessons(
        widget.courseId,
      );
      setState(() {
        _course = course;
        _completedLessons = completedLessons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load course lessons',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_course == null) {
      return const Center(child: Text('No Lessons Available'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _course!.lessons.length,
      itemBuilder: (context, index) {
        final lesson = _course!.lessons[index];
        final isLocked =
            !lesson.isPreview &&
            (index > 0 &&
                !DummyDataService.isLessonCompleted(
                  _course!.id,
                  _course!.lessons[index - 1].id,
                ));
        return LessonTile(
          title: lesson.title,
          duration: '${lesson.duration} mins',
          isCompleted: DummyDataService.isLessonCompleted(_course!.id, lesson.id),
          isLocked: isLocked,

          isUnlocked: widget.isUnlocked,
          onTap: () async {
            if (_course!.isPremium && !widget.isUnlocked) {
              Get.snackbar(
                'Premium Course',
                'Please purchase this course to access all lessons',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else if (isLocked) {
              Get.snackbar(
                'Lesson Locked',
                'Please complete the previous lesson to start',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
            } else {
              final result = await Get.toNamed(
                AppRoutes.lesson.replaceAll(':id', lesson.id),
                parameters: {'courseId': widget.courseId},
              );
              if (result == true) {
                widget.onLessonComplete?.call();
              }
            }
          },
        );
      },
    );
  }
}
