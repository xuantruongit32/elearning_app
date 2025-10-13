import 'package:better_player_plus/better_player_plus.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonVideoController {
  BetterPlayerController? betterPlayerController;
  bool isLoading = true;
  final String lessonId;
  final Function(bool) onLoadingChanged;
  final Function(Course) onCertificateEarned;

  LessonVideoController({
    required this.lessonId,
    required this.onLoadingChanged,
    required this.onCertificateEarned,
  });

  Future<void> initializeVideo() async {
    try {
      final courseId = Get.parameters['courseId'];
      debugPrint('CourseID: $courseId');

      if (courseId == null) {
        debugPrint('No courseId found in parameters');
        onLoadingChanged(false);
        return;
      }

      final course = DummyDataService.getCourseById(courseId);
      debugPrint("Course found: ${course.title}");

      if (course.isPremium && !DummyDataService.isCourseUnlocked(courseId)) {
        onLoadingChanged(false);
        Get.back();
        Get.toNamed(
          AppRoutes.payment,
          arguments: {
            'courseId': courseId,
            'courseName': course.title,
            'price': course.price,
          },
        );
        return;
      }

      final lesson = course.lessons.firstWhere(
        (lesson) => lesson.id == lessonId,
        orElse: () => course.lessons.first,
      );

      debugPrint("Loading video: ${lesson.videoStreamUrl}");

      final betterPlayerConfiguration = const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        handleLifecycle: true,
        autoDetectFullscreenAspectRatio: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enablePlayPause: true,
          enableMute: true,
          enableProgressText: true,
          enableProgressBar: true,
        ),
      );

      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        lesson.videoStreamUrl,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: false,
        ),
      );

      betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );

      onLoadingChanged(false);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      onLoadingChanged(false);
    }
  }

  void markLessonAsCompleted(String courseId) {
    final course = DummyDataService.getCourseById(courseId);
    final lessonIndex = course.lessons.indexWhere((l) => l.id == lessonId);

    if (lessonIndex != -1) {
      DummyDataService.updateLessonStatus(
        courseId,
        lessonId,
        isCompleted: true,
      );
    }

    if (lessonIndex < course.lessons.length - 1) {
      DummyDataService.updateLessonStatus(
        courseId,
        course.lessons[lessonIndex + 1].id,
        isCompleted: false,
      );
    }

    final isLastLesson = lessonIndex == course.lessons.length - 1;
    final allLessonsCompleted = DummyDataService.isCourseCompleted(courseId);

    Get.back(result: true);

    if (isLastLesson && allLessonsCompleted) {
      onCertificateEarned(course);
    } else {
      Get.snackbar(
        'Lesson Completed',
        'You can now proceed to the next lesson',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void dispose() {
    betterPlayerController?.dispose();
  }
}
