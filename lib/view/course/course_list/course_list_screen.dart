import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/course/course_list/widgets/course_card.dart';
import 'package:elearning_app/view/course/course_list/widgets/course_filter_dialog.dart';
import 'package:elearning_app/view/course/course_list/widgets/empty_state_widget.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CourseListScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final bool showBackButton;
  const CourseListScreen({
    super.key,
    this.categoryId,
    this.categoryName,
    this.showBackButton = false,
  });

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();

    //load courses when screen initialize
    if (widget.categoryId != null) {
      context.read<FilteredCourseBloc>().add(
        FilterCoursesByCategory(widget.categoryId!),
      );
    } else {
      context.read<CourseBloc>().add(LoadCourses());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                automaticallyImplyLeading:
                    widget.categoryId != null || widget.showBackButton,
                leading: (widget.categoryId != null || widget.showBackButton)
                    ? IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                      )
                    : null,
                actions: [
                  IconButton(
                    onPressed: () => _showFilterDialog(context),
                    icon: const Icon(
                      Icons.filter_list,
                      color: AppColors.accent,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(6),
                  title: Text(
                    widget.categoryName ?? 'All Courses',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              if (state is CourseLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerCourseCard(),
                      childCount: 5,
                    ),
                  ),
                )
              else if (state is CourseError)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                )
              else if (state is CoursesLoaded && state.courses.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateWidget(onActionPressed: () => Get.back()),
                )
              else if (state is CoursesLoaded)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final course = state.courses[index];
                      return CourseCard(
                        courseId: course.id,
                        title: course.title,
                        subtitle: course.description,
                        imageUrl: course.imageUrl,
                        rating: course.rating,
                        duration: '${course.lessons.length * 30} mins',
                        isPremium: course.isPremium,
                      );
                    }, childCount: state.courses.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CourseFilterDialog(),
    );
  }
}
