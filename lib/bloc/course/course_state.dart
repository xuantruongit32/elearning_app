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
  final Course? selectedCourse;
  final bool? isSelectedCourseCompleted;
  final Set<String> enrolledCourseIds;
  final bool isEnrolled;

  CoursesLoaded(
    this.courses, {
    this.selectedCourse,
    this.isSelectedCourseCompleted,
    this.enrolledCourseIds = const {},
    this.isEnrolled = false,
  });

  CoursesLoaded copyWith({
    List<Course>? courses,
    Course? selectedCourse,
    bool? isSelectedCourseCompleted,
    Set<String>? enrolledCourseIds,
    bool? isEnrolled,
  }) {
    return CoursesLoaded(
      courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      isSelectedCourseCompleted:
          isSelectedCourseCompleted ?? this.isSelectedCourseCompleted,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }

  List<Object?> get props => [
    courses,
    selectedCourse,
    isSelectedCourseCompleted,
    enrolledCourseIds,
    isEnrolled,
  ];
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

class CourseDeleted extends CourseState {
  final String message;
  CourseDeleted(this.message);
}
