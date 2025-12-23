import 'package:bloc/bloc.dart';
import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/bloc/course/course_state.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_repository.dart';

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
      final userId = _authBloc.state.userModel?.uid;
      Set<String> enrolledIds = {}; 

      if (userId != null) {
        final results = await Future.wait([
          _courseRepository.getCourses(),
          _courseRepository.getEnrolledCourseIds(userId),
        ]);

        final courses = results[0] as List<Course>;
        enrolledIds = results[1] as Set<String>; 

        emit(CoursesLoaded(courses, enrolledCourseIds: enrolledIds));
      } else {
        final courses = await _courseRepository.getCourses();
        emit(
          CoursesLoaded(courses, enrolledCourseIds: enrolledIds),
        ); 
      }
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
    }
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetail event, 
    Emitter<CourseState> emit,
  ) async {
    
    if (state is CoursesLoaded) {
      final currentState = state as CoursesLoaded;
      emit(currentState.copyWith(selectedCourse: null));
    } else {
      emit(CourseLoading());
    }

    try {
      final userId = _authBloc.state.userModel?.uid;

      Course course;
      bool isCompleted = false;
      bool isEnrolled = false; // 

      if (userId != null) {
        final results = await Future.wait([
          _courseRepository.getCourseDetail(event.courseId),
          _courseRepository.isCourseCompleted(event.courseId, userId),
          _courseRepository.isEnrolled(
            event.courseId,
            userId,
          ), 
        ]);

        course = results[0] as Course;
        isCompleted = results[1] as bool;
        isEnrolled = results[2] as bool; 
      } else {
        course = await _courseRepository.getCourseDetail(event.courseId);
      }

      if (state is CoursesLoaded) {
        final currentState = state as CoursesLoaded;
        emit(
          currentState.copyWith(
            selectedCourse: course,
            isSelectedCourseCompleted: isCompleted,
            isEnrolled: isEnrolled, 
          ),
        );
      } else {
        final courses = await _courseRepository.getCourses();
        emit(
          CoursesLoaded(
            courses,
            selectedCourse: course,
            isSelectedCourseCompleted: isCompleted,
            isEnrolled: isEnrolled, 
          ),
        );
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
      await _courseRepository.deleteCourse(event.courseId);

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
