import 'package:better_player_plus/better_player_plus.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonVideoController {
  BetterPlayerController? betterPlayerController;
  bool isLoading = true;
  final String lessonId;
  final Function(bool) onLoadingChanged;
  final Function(Course) onCertificateEarned;
  final CourseRepository _courseRepository;
  final FirebaseAuth _auth;

  LessonVideoController({
    required this.lessonId,
    required this.onLoadingChanged,
    required this.onCertificateEarned,
  }) : _courseRepository = CourseRepository(),
       _auth = FirebaseAuth.instance;

  Future<void> initializeVideo() async {
    try {
      if (betterPlayerController != null) {
        await betterPlayerController!.pause();
        betterPlayerController!.dispose();
        betterPlayerController = null;
        debugPrint('Disposed old BetterPlayerController');
      }
      onLoadingChanged(true);
      final courseId = Get.parameters['courseId'];
      debugPrint('CourseID: $courseId');

      if (courseId == null) {
        debugPrint('No courseId found in parameters');
        onLoadingChanged(false);
        return;
      }

      final user = _auth.currentUser;
      if (user == null) {
        debugPrint("No user logged in");
        onLoadingChanged(false);
        return;
      }

      final course = await _courseRepository.getCourseDetail(courseId);
      debugPrint("Course found: ${course.title}");

      // check if lesson is unlocked for this student
      final isUnlocked = await _courseRepository.isLessonUnlocked(
        courseId,
        lessonId,
        user.uid,
      );
      final isEnrolled = await _courseRepository.isEnrolled(courseId, user.uid);

      if (!isUnlocked) {
        onLoadingChanged(false);
        Get.back();
        Get.snackbar(
          'Lesson Locked',
          'Please complete previous lessons first',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      if (course.isPremium && !isEnrolled) {
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
      // if this is the first lesson of a non-premium course and user is not enrolled
      if (!course.isPremium &&
          !isEnrolled &&
          course.lessons.first.id == lessonId) {
        await _courseRepository.enrollInCourse(courseId, user.uid);
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
        "${lesson.videoStreamUrl}?v=${DateTime.now().millisecondsSinceEpoch}",
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: false,
        ),
      );

      betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );

      betterPlayerController!.addEventsListener(_onBetterPlayerEvent);
      await Future.delayed(const Duration(milliseconds: 200));

      onLoadingChanged(false);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      onLoadingChanged(false);
    }
  }

  void _onBetterPlayerEvent(BetterPlayerEvent event) async {
    final courseId = Get.parameters['courseId'];
    if (courseId == null) return;

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.finished:
        debugPrint('🎯 Video finished!');
        await markLessonAsCompleted(courseId);
        break;

      case BetterPlayerEventType.progress:
        final position =
            betterPlayerController?.videoPlayerController?.value.position;
        final duration =
            betterPlayerController?.videoPlayerController?.value.duration;
        if (position != null && duration != null) {
          final progress = position.inSeconds / duration.inSeconds;
          debugPrint('Progress: ${(progress * 100).toStringAsFixed(1)}%');
        }
        break;

      default:
        break;
    }
  }

  Future<void> markLessonAsCompleted(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      final course = await _courseRepository.getCourseDetail(courseId);
      final lessonIndex = course.lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex == -1) return;
      final completedLessons = await _courseRepository.getCompletedLessons(
        courseId,
        user.uid,
      );
      if (!completedLessons.contains(lessonId)) {
        // mark lesson as completed (this will also update course progress)
        await _courseRepository.markLessonAsCompleted(
          courseId,
          lessonId,
          user.uid,
        );
        //
        if (lessonIndex < course.lessons.length - 1) {
          await _courseRepository.unlockLesson(
            courseId,
            course.lessons[lessonIndex + 1].id,
            user.uid,
          );
        }
        final isLastLesson = lessonIndex == course.lessons.length - 1;
        final allLessonsCompleted =
            completedLessons.length + 1 == course.lessons.length;
        // get updated progress
        final progress = await _courseRepository.getCourseProgress(
          courseId,
          user.uid,
        );
        Get.back(result: true);

        if (isLastLesson && allLessonsCompleted) {
          onCertificateEarned(course);
        } else {
          Get.snackbar(
            'Lesson Completed',
            'Course Progress:${progress.toStringAsFixed(1)}%',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      debugPrint('Error marking lesson as completed: $e');
    }
  }

  void dispose() {
    if (betterPlayerController != null) {
      try {
        betterPlayerController!.removeEventsListener(_onBetterPlayerEvent);
      } catch (_) {}
      //      betterPlayerController!.dispose(forceDispose: true);
      betterPlayerController = null;
      debugPrint("🎬 BetterPlayerController disposed completely");
    }
    isLoading = false;
  }
}
