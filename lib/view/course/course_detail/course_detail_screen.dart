import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/course/course_detail/widgets/action_buttons.dart';
import 'package:elearning_app/view/course/course_detail/widgets/course_detail_app_bar.dart';
import 'package:elearning_app/view/course/course_detail/widgets/course_info_card.dart';
import 'package:elearning_app/view/course/course_detail/widgets/lesson_list.dart';
import 'package:elearning_app/view/course/course_detail/widgets/reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with RouteAware {
  @override
  void didPopNext() {
    // this is called when returning to this screen
    _loadCourseDetail();
  }

  bool _isUnlocked = false;
  final RouteObserver<PageRoute> _routeObserver =
      Get.find<RouteObserver<PageRoute>>();

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourseDetail(widget.courseId));
  }

  void _loadCourseDetail() {
    context.read<CourseBloc>().add(LoadCourseDetail(widget.courseId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastLesson = Get.parameters['latestlesson'];

    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        //show loading scaffold when in loading state or when selected course is null  in CourseLoaded state
        if (state is CourseLoading ||
            (state is CoursesLoaded && state.selectedCourse == null)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is CourseError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.message)),
          );
        }

        if (state is CoursesLoaded && state.selectedCourse != null) {
          final course = state.selectedCourse!;
          //if in progress -> scroll to last lesson
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (lastLesson != null) {
              // implement scroll to jast lesson logic here
            }
          });
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                CourseDetailAppBar(imageUrl: course.imageUrl),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toString(),
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${course.reviewCount} reviews)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${course.price}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          course.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        CourseInfoCard(course: course),
                        const SizedBox(height: 24),
                        Text(
                          'Course Content',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LessonList(
                          courseId: widget.courseId,
                          isUnlocked: _isUnlocked,
                          onLessonComplete: () => setState(() {}),
                        ),
                        const SizedBox(height: 24),
                        ReviewsSection(courseId: widget.courseId),
                        const SizedBox(height: 16),
                        ActionButtons(course: course, isUnlocked: _isUnlocked),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: course.isPremium && !_isUnlocked
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // navigate to payment
                        Get.toNamed(
                          AppRoutes.payment,
                          arguments: {
                            'courseId': widget.courseId,
                            'courseName': course.title,
                            'price': course.price,
                          },
                        )?.then((_) {
                          setState(() {});
                        });
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text('Buy Now for \$${course.price}'),
                    ),
                  )
                : null,
          );
        }
        return const Scaffold(body: Center(child: Text('Something wrong')));
      },
    );
  }
}
