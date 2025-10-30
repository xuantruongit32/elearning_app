import 'package:elearning_app/models/course.dart';

abstract class FilteredCourseState {
  get courses => null;
}

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
  final Set<String> enrolledCourseIds;

  FilteredCoursesLoaded(
    this.courses, {
    this.categoryId,
    this.level,
    this.searchQuery,
    this.enrolledCourseIds = const {},
  });

  FilteredCoursesLoaded copyWith({
    List<Course>? courses,
    String? categoryId,
    String? level,
    String? searchQuery,
    Set<String>? enrolledCourseIds,
  }) {
    return FilteredCoursesLoaded(
      courses ?? this.courses,
      categoryId: categoryId ?? this.categoryId,
      level: level ?? this.level,
      searchQuery: searchQuery ?? this.searchQuery,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
    );
  }
}
