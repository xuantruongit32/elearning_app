import 'package:bloc/bloc.dart';
import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/respositories/course_respository.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  final AuthBloc _authBloc;

  CourseBloc({
    required CourseRepository courseRepository,
    required AuthBloc authBloc,
  }) : _courseRepository = courseRepository,
       _authBloc = authBloc,
       super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseDetail>(_onLoadCourseDetail);
    on<EnrollCourse>(_onEnrollCourse);
    on<LoadEnrolledCourses>(_onLoadEnrolledCourse);
    on<LoadOfflineCourses>(_onLoadOfflineCourses);
    on<UpdateCourse>(_onUpdateCourse);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    //code later
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetail event,
    Emitter<CourseState> emit,
  ) async {
    //code later
  }

  Future<void> _onEnrollCourse(
    EnrollCourse event,
    Emitter<CourseState> emit,
  ) async {
    //code later
  }

  Future<void> _onLoadEnrolledCourse(
    LoadEnrolledCourses event,
    Emitter<CourseState> emit,
  ) async {
    //code later
  }

  Future<void> _onLoadOfflineCourses(
    LoadOfflineCourses event,
    Emitter<CourseState> emit,
  ) async {
    //code later
  }

  Future<void> _onUpdateCourse(
    UpdateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await _courseRepository.getInstructorCourses(
        event.instructorId,
      );
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
