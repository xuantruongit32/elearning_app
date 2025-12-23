// DÁN TOÀN BỘ CODE NÀY VÀO FILE: RecommendedSection.dart

import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/respositories/instructor_respositories.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/home/widgets/recommended_course_card.dart';
import 'package:elearning_app/view/home/widgets/shimmer_recommeneded_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  final _instructorRepository = InstructorRepository();
  Map<String, UserModel> _instructors = {};

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourses());
  }

  Future<void> _loadInstructors(List<Course> courses) async {
    final instructorIds = courses.map((c) => c.instructorId).toList();

    try {
      _instructors = await _instructorRepository.getInstructorsByIds(
        instructorIds,
      );
    } catch (e) {
      // Bỏ qua lỗi nếu có
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CoursesLoaded) {
          _loadInstructors(state.courses);
        }
      },
      builder: (context, state) {
        if (state is CourseLoading) {
          return const ShimmerRecommenededSection();
        }

        if (state is CoursesLoaded) {
          final courses = state.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('Không có khóa học nào'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gợi ý cho bạn',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.courseList),
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
               
                height: 280,
                child: PageView.builder(
                  physics: const PageScrollPhysics(), 
                  controller: PageController(
               
                    viewportFraction: 0.85,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final instructor = _instructors[course.instructorId];

                    return Padding(
                 
                      padding: const EdgeInsets.only(right: 16, bottom: 5),
                      child: RecommendedCourseCard(
                        courseId: course.id,
                        title: course.title,
                        imageUrl: course.imageUrl,
                        instructorName: instructor?.fullName ?? 'Giảng viên',
                        isPremium: course.isPremium,
                        price: course.price,
                        rating: course.rating,
                        reviewCount: course.reviewCount,
                        onTap: () => Get.toNamed(
                          AppRoutes.courseDetail.replaceAll(':id', course.id),
                          arguments: course.id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        if (state is CourseError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
