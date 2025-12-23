import 'dart:async';

import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/course/course_list/widgets/course_card.dart';
import 'package:elearning_app/view/course/course_list/widgets/empty_state_widget.dart';
import 'package:elearning_app/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CourseSearchScreen extends StatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  final _searchController = TextEditingController();
  final _debounce = Debouncer(milliseconds: 500);
  final _focusNode = FocusNode();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce.run(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<FilteredCourseBloc>().add(SearchCourses(query));
      } else {
        context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.accent),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: const TextStyle(color: AppColors.primary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm khóa học...',
              hintStyle: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.7),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.primary.withValues(alpha: 0.7),
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<FilteredCourseBloc>().add(
                          ClearFilteredCourses(),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.primary.withValues(alpha: 0.7),
                          size: 18,
                        ),
                      ),
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ),
      body: BlocBuilder<FilteredCourseBloc, FilteredCourseState>(
        builder: (context, state) {
          if (state is FilteredCourseLoading) {
            return ListView.builder(
              itemBuilder: (context, index) => const ShimmerCourseCard(),
            );
          }

          if (state is FilteredCourseError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.error),
              ),
            );
          }
          if (state is FilteredCoursesLoaded) {
            if (state.courses.isEmpty) {
              return EmptyStateWidget(
                message: 'Không tìm thấy khóa học nào',
                onActionPressed: () {
                  _searchController.clear();
                  context.read<FilteredCourseBloc>().add(
                    ClearFilteredCourses(),
                  );
                },
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return CourseCard(
                  courseId: course.id,
                  title: course.title,
                  subtitle: course.description,
                  imageUrl: course.imageUrl,
                  rating: course.rating,
                  duration: '${course.lessons.length * 30} phút', // tạm thời
                  isPremium: course.isPremium,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
