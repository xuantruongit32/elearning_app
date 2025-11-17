import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
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
  String? _currentLevel;
  bool _showPurchasedOnly = false;

  @override
  void initState() {
    super.initState();

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
      body: widget.categoryId != null
          ? _buildFilteredCourselist(theme)
          : _buildAllCourselist(theme),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CourseFilterDialog(
        onLevelSelected: _handleLevelFilter,
        initialLevel: _currentLevel,
        onPurchasedToggle: _handlePurchasedFilter,
        initialShowPurchased: _showPurchasedOnly,
      ),
    );
  }

  void _handlePurchasedFilter(bool isPurchased) {
    setState(() {
      _showPurchasedOnly = isPurchased;
    });
  }

  void _handleLevelFilter(String level) {
    setState(() {
      _currentLevel = level == 'All' ? null : level;
    });

    if (widget.categoryId != null) {
      // Dùng FilteredCourseBloc cho các khóa học theo danh mục
      if (level == 'All') {
        context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
      } else {
        context.read<FilteredCourseBloc>().add(FilterCoursesByLevel(level));
      }
    } else {
      // Với tất cả khóa học, chỉ cần tải lại và lọc trong UI
      context.read<CourseBloc>().add(LoadCourses());
    }
  }

  Widget _buildFilteredCourselist(ThemeData theme) {
    return BlocBuilder<FilteredCourseBloc, FilteredCourseState>(
      builder: (context, state) {
        List<Course>? finalCourses;

        if (state is FilteredCoursesLoaded) {
          final enrolledIds = state.enrolledCourseIds;
          finalCourses = _filterCoursesByPurchased(state.courses, enrolledIds);
        }

        return _buildCourseListView(
          theme: theme,
          isLoading: state is FilteredCourseLoading,
          error: state is FilteredCourseError ? state.message : null,
          courses: finalCourses,
        );
      },
    );
  }

  Widget _buildAllCourselist(ThemeData theme) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        List<Course>? finalCourses;

        if (state is CoursesLoaded) {
          final enrolledIds = state.enrolledCourseIds;
          var levelFiltered = _filterCoursesByLevel(state.courses);
          finalCourses = _filterCoursesByPurchased(levelFiltered, enrolledIds);
        }

        return _buildCourseListView(
          theme: theme,
          isLoading: state is CourseLoading,
          error: state is CourseError ? state.message : null,
          courses: finalCourses,
        );
      },
    );
  }

  Widget _buildCourseListView({
    required ThemeData theme,
    required bool isLoading,
    String? error,
    List<Course>? courses,
  }) {
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
                  onPressed: () {
                    Get.back();

                    if (widget.categoryId != null) {
                      context.read<FilteredCourseBloc>().add(
                        ClearFilteredCourses(),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                )
              : null,
          actions: [
            IconButton(
              onPressed: () => _showFilterDialog(context),
              icon: const Icon(Icons.filter_list, color: AppColors.accent),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(6),
            title: Text(
              _buildScreenTitle(),
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
        if (isLoading)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ShimmerCourseCard(),
                childCount: 5,
              ),
            ),
          )
        else if (error != null)
          SliverFillRemaining(
            child: Center(
              child: Text(
                error,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          )
        else if (courses == null || courses.isEmpty)
          SliverFillRemaining(
            child: EmptyStateWidget(
              message: 'Không có khóa học nào',
              onActionPressed: () => Get.back(),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final course = courses[index];
                return CourseCard(
                  courseId: course.id,
                  title: course.title,
                  subtitle: course.description,
                  imageUrl: course.imageUrl,
                  rating: course.rating,
                  duration: '${course.lessons.length * 30} phút',
                  isPremium: course.isPremium,
                );
              }, childCount: courses.length),
            ),
          ),
      ],
    );
  }

  List<Course> _filterCoursesByPurchased(
    List<Course> courses,
    Set<String> enrolledIds,
  ) {
    if (!_showPurchasedOnly) {
      return courses;
    }
    return courses.where((course) => enrolledIds.contains(course.id)).toList();
  }

  List<Course> _filterCoursesByLevel(List<Course> courses) {
    if (_currentLevel == null || _currentLevel == 'All') {
      return courses;
    }
    return courses.where((course) => course.level == _currentLevel).toList();
  }

  String _buildScreenTitle() {
    final List<String> titleParts = [];

    if (widget.categoryName != null) {
      titleParts.add(widget.categoryName!);
    }

    if (_currentLevel != null &&
        _currentLevel != 'All' &&
        _currentLevel != 'Tất cả trình độ') {
      String displayLevel =
          CourseFilterDialog.levelDisplayMap[_currentLevel] ?? _currentLevel!;
      titleParts.add(displayLevel);
    }

    if (_showPurchasedOnly) {
      titleParts.add('Đã mua');
    }

    if (titleParts.isEmpty) {
      return 'Tất cả khóa học';
    }
    return titleParts.join(' - ');
  }
}
