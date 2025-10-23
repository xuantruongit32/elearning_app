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
    on<RefreshCourseDetail>(_onRefreshCourseDetail);

    on<EnrollCourse>(_onEnrollCourse);
    on<LoadEnrolledCourses>(_onLoadEnrolledCourse);
    on<LoadOfflineCourses>(_onLoadOfflineCourses);
    on<UpdateCourse>(_onUpdateCourse);
    on<DeleteCourse>(_onDeleteCourse);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await _courseRepository.getCourses(
        categoryId: event.categoryId,
      );
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onRefreshCourseDetail(
    RefreshCourseDetail event,
    Emitter<CourseState> emit,
  ) async {
    try {
      if (state is CourseDetailLoaded) {
        final course = await _courseRepository.getCourseDetail(event.courseId);
        emit(CourseDetailLoaded(course));
      }
    } catch (e) {
      // don't emit error state to preserve current state
    }
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetail event,
    Emitter<CourseState> emit,
  ) async {
    // first emit loading state
    if (state is CoursesLoaded) {
      final currentState = state as CoursesLoaded;
      emit(CoursesLoaded(currentState.courses, selectedCourse: null));
    } else {
      emit(CourseLoading());
    }
    try {
      final course = await _courseRepository.getCourseDetail(event.courseId);

      // if we already have a courses list, update it with the selected course
      if (state is CoursesLoaded) {
        final currentState = state as CoursesLoaded;
        emit(currentState.copyWith(selectedCourse: course));
      } else {
        // if we don't have a courses list, load all courses and set the selected on
        final courses = await _courseRepository.getCourses();
        emit(CoursesLoaded(courses, selectedCourse: course));
      }
    } catch (e) {
      emit(CourseError(e.toString()));
    }
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

  Future<void> _onDeleteCourse(
    DeleteCourse event,
    Emitter<CourseState> emit,
  ) async {
    try {
      // Gọi Repository để thực hiện việc xóa khóa học trong database (như Firestore)
      await _courseRepository.deleteCourse(event.courseId);

      // Lấy ID người dùng hiện tại
      final userId = _authBloc.state.userModel?.uid;

      if (userId != null) {
        final courses = await _courseRepository.getInstructorCourses(userId);

        emit(CourseDeleted('Course deleted successfully'));

        emit(CoursesLoaded(courses));
      }
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
