import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/user_service.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/empty_courses_state.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/my_courses_app_bar.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/teacher_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final instructorId = userService.getCurrentUserId();

    if (instructorId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
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
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerCourseCard(),
            ),
          );
        } else if (state is CourseError) {
          return Center(child: Text('Error: \\${state.message}'));
        } else if (state is CoursesLoaded) {
          final teacherCourses = state.courses;
          if (teacherCourses.isEmpty) {
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
          }

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
        } else {
          context.read<CourseBloc>().add(UpdateCourse(instructorId));
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
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerCourseCard(),
            ),
          );
        }
      },
    );
  }
}
