import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:elearning_app/services/user_service.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/empty_courses_state.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/my_courses_app_bar.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/teacher_course_card.dart';
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseRepository = CourseRepository();
    final userService = UserService();
    final instructorId = userService.getCurrentUserId();

    if (instructorId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return FutureBuilder<List<Course>>(
      future: courseRepository.getInstructorCourses(instructorId),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              title: const Text('My Courses'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(), //loading state - code later
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              title: const Text('My Courses'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: const EmptyCoursesState(),
          );
        } else {
          final teacherCourses = snapshot.data!;

          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const MyCoursesAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          TeacherCourseCard(course: teacherCourses[index]),
                      childCount: teacherCourses.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
