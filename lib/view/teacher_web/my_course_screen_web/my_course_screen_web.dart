import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/user_service.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/empty_courses_state.dart';

import 'package:elearning_app/view/teacher_web/my_course_screen_web/widgets/my_course_appbar.dart';
import 'package:elearning_app/view/teacher_web/my_course_screen_web/widgets/shimmer_course_card_web.dart';
import 'package:elearning_app/view/teacher_web/my_course_screen_web/widgets/teacher_course_card_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyCoursesScreenWeb extends StatefulWidget {
  const MyCoursesScreenWeb({super.key});

  @override
  State<MyCoursesScreenWeb> createState() => _MyCoursesScreenWebState();
}

class _MyCoursesScreenWebState extends State<MyCoursesScreenWeb> {
  @override
  void initState() {
    super.initState();
    final userService = UserService();
    final instructorId = userService.getCurrentUserId();
    if (instructorId != null) {
      context.read<CourseBloc>().add(UpdateCourse(instructorId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final instructorId = userService.getCurrentUserId();

    if (instructorId == null) {
      return const Scaffold(
        body: Center(child: Text('Người dùng chưa đăng nhập')),
      );
    }

    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CourseDeleted) {
          Fluttertoast.showToast(
            msg: state.message,
            webBgColor: "linear-gradient(to right, #4CAF50, #4CAF50)",
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state is CourseLoading) {
          return _buildLayout(
            context,
            isLoading: true,
            contentSliver: SliverToBoxAdapter(child: Container()),
          );
        }

        if (state is CourseError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: const BackButton(color: Colors.white),
            ),
            body: Center(child: Text('Lỗi: ${state.message}')),
          );
        }

        if (state is CoursesLoaded) {
          final teacherCourses = state.courses;
          if (teacherCourses.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.lightBackground,
              appBar: AppBar(
                title: const Text('Khóa học của tôi'),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              body: const EmptyCoursesState(),
            );
          }

          return _buildLayout(
            context,
            isLoading: false,
            itemCount: teacherCourses.length,
            itemBuilder: (context, index) =>
                TeacherCourseCardWeb(course: teacherCourses[index]),
          );
        }

        return _buildLayout(
          context,
          isLoading: true,
          contentSliver: SliverToBoxAdapter(child: Container()),
        );
      },
    );
  }

  Widget _buildLayout(
    BuildContext context, {
    required bool isLoading,
    Widget? contentSliver,
    int? itemCount,
    Widget Function(BuildContext, int)? itemBuilder,
  }) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      // Đã loại bỏ LayoutBuilder và kiểm tra isWeb
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const MyCoursesAppBarWeb(),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: isLoading
                ? SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerCourseCardWeb(),
                      childCount: 6,
                    ),
                  )
                : (contentSliver ??
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                              childAspectRatio: 0.75,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          itemBuilder!,
                          childCount: itemCount!,
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
