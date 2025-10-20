import 'package:elearning_app/models/course.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);
}

class CoursesLoaded extends CourseState {
  final List<Course> courses;

  CoursesLoaded(this.courses);
}

class CourseDetailLoaded extends CourseState {
  final Course course;

  CourseDetailLoaded(this.course);
}

class EnrolledCoursesLoaded extends CourseState {
  final List<Course> courses;

  EnrolledCoursesLoaded(this.courses);
}

class OfflineCoursesLoaded extends CourseState {
  final List<Course> courses;

  OfflineCoursesLoaded(this.courses);
}
