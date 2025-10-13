import 'package:chewie/chewie.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LessonVideoController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
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
      }
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
      videoPlayerController = VideoPlayerController.network(
        lesson.videoStreamUrl,
      );
      await videoPlayerController?.initialize();
      videoPlayerController?.addListener(
        () => onVideoProgressChanged(courseId),
      );

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              "Error: Unable to load video content",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.red),
            ),
          );
        },
      );
      onLoadingChanged(false);
    } catch (e) {
      debugPrint('Error initializing video" $e');
      onLoadingChanged(false);
    }
  }

  void onVideoProgressChanged(String courseId) {
    if (videoPlayerController != null &&
        videoPlayerController!.value.position >=
            videoPlayerController!.value.duration) {
      markLessonAsCompleted(courseId);
      videoPlayerController?.removeListener(
        () => onVideoProgressChanged(courseId),
      );
    }
  }

  void markLessonAsCompleted(String courseId) async {
    if (courseId != null) {
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
  }

  void dispose() {
    videoPlayerController?.removeListener(
      () => onVideoProgressChanged(Get.parameters['courseId'] ?? ''),
    );
    videoPlayerController?.dispose();
    chewieController?.dispose();
  }
}
