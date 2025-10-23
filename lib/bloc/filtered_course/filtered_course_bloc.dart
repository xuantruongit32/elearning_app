import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_state.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredCourseBloc
    extends Bloc<FilteredCourseEvent, FilteredCourseState> {
  final CourseRepository _courseRepository;

  FilteredCourseBloc({required CourseRepository courseRepository})
    : _courseRepository = courseRepository,
      super(FilteredCourseInitial()) {
    on<FilterCoursesByCategory>(_onFilterCoursesByCategory);
    on<ClearFilteredCourses>(_onClearFilteredCourses);
  }

  Future<void> _onFilterCoursesByCategory(
    FilterCoursesByCategory event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      final courses = await _courseRepository.getCourses(
        categoryId: event.categoryId,
      );
      emit(FilteredCoursesLoaded(courses, event.categoryId));
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  void _onClearFilteredCourses(
    ClearFilteredCourses event,
    Emitter<FilteredCourseState> emit,
  ) {
    emit(FilteredCourseInitial());
  }
}
