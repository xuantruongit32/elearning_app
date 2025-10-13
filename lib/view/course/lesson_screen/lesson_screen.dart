import 'package:chewie/chewie.dart';
import 'package:elearning_app/controllers/video_controller.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final LessonVideoController _videoController;
  bool _isLoading = true;

  void initState() {
    super.initState();
    _videoController = LessonVideoController(
      lessonId: widget.lessonId,
      onLoadingChanged: (bool loading) {
        setState(fn: () => _isLoading = loading);
      },
      onCertificateEarned: (Course course) {
        if (mounted) {
          _showCertificateDialog(context, course);
        }
      },
    );
    _videoController.initializeVideo();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _showCertificateDialog(BuildContext context, Course course) {}
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? courseId = Get.parameters['courseId'];
    final Course? course = courseId != null
        ? DummyDataService.getCourseById(courseId)
        : null;
    final bool isUnlocked = courseId != null
        ? DummyDataService.isCourseUnlocked(courseId)
        : false;

    if (course == null) {
      return const Scaffold(body: Center(child: Text('Course not found')));
    }
    if (course.isPremium && !isUnlocked) {
      return Scaffold(body: Center(child: Text("Please purchase this course")));
    }

    final Lesson lesson = course.lessons.firstWhere(
      (Lesson l) => l.id == widget.lessonId,
      orElse: () => course.lessons.first,
    );
    return Scaffold(
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isLoading
                ? Container(
                    color: theme.colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : _videoController.chewieController != null
                ? Chewie(controller: _videoController.chewieController!)
                : Container(
                    color: theme.colorScheme.surface,
                    child: const Center(child: Text('Error loading video')),
                  ),
          ),
        ],
      ),
    );
  }
}
