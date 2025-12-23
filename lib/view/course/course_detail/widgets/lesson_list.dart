import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/course/course_detail/widgets/lesson_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(LessonList oldWidget) {
    super.didUpdateWidget(oldWidget);
// reload course when widget is updated, courseId changes, or isUnlocked changes
    if (oldWidget.courseId != widget.courseId ||
        oldWidget.isUnlocked != widget.isUnlocked) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Lỗi',
        'Vui lòng đăng nhập để xem tiến trình khóa học',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      final course = await _courseRepository.getCourseDetail(widget.courseId);
      final completedLessons = await _courseRepository.getCompletedLessons(
        widget.courseId,
        user.uid,
      );
      if (mounted) {
        setState(() {
          _course = course;
          _completedLessons = completedLessons;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Lỗi',
          'Không thể tải danh sách bài học',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_course == null) {
      return const Center(child: Text('Không có bài học nào'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _course!.lessons.length,
      itemBuilder: (context, index) {
        final lesson = _course!.lessons[index];
        final _isCompleted = _completedLessons.contains(lesson.id);
        final isLocked =
            !lesson.isPreview &&
            (index > 0 &&
                !_completedLessons.contains(_course!.lessons[index - 1].id));

        return LessonTile(
          title: lesson.title,
          duration: '${lesson.duration} phút',
          isCompleted: _isCompleted,
          isLocked: isLocked,
          isUnlocked: widget.isUnlocked,
          onTap: () async {
            if (_course!.isPremium && !widget.isUnlocked) {
              Get.snackbar(
                'Khóa học cao cấp',
                'Vui lòng mua khóa học để truy cập tất cả bài học',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else if (isLocked) {
              Get.snackbar(
                'Bài học bị khóa',
                'Vui lòng hoàn thành bài học trước đó để tiếp tục',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else {
              final result = await Get.toNamed(
                AppRoutes.lesson.replaceAll(':id', lesson.id),
                parameters: {'courseId': widget.courseId},
              );
              if (result == true) {
                await _loadCourse(); //reload course data when return from lesson
                widget.onLessonComplete?.call(); //notify parent about completion
              }
            }
          },
        );
      },
    );
  }
}
