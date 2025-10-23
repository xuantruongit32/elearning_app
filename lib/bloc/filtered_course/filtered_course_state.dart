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
  final String categoryId;
  
  FilteredCoursesLoaded(this.categoryId, this.courses);
}