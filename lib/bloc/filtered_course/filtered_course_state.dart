import 'package:elearning_app/models/course.dart';

abstract class FilteredCourseState {}

class FilteredCourseInitial extends FilteredCourseState {}

class FilteredCourseLoading extends FilteredCourseState {}

class FilteredCourseError extends FilteredCourseState {
  final String message;

  FilteredCourseError(this.message);
}

class FilteredCoursesLoaded extends FilteredCourseState {
  final List<Course> courses;
  final String? categoryId;
  final String? level;
  final String? searchQuery;

  FilteredCoursesLoaded(
    this.courses, {
    this.categoryId,
    this.level,
    this.searchQuery,
  });

  FilteredCoursesLoaded copyWith({
    List<Course>? courses,
    String? categoryId,
    String? level,
    String? searchQuery,
  }) {
    return FilteredCoursesLoaded(
      courses ?? this.courses,
      categoryId: categoryId ?? this.categoryId,
      level: level ?? this.level,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
