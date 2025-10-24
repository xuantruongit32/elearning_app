import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_state.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredCourseBloc
    extends Bloc<FilteredCourseEvent, FilteredCourseState> {
  final CourseRepository _courseRepository;
  String? _currentCategoryId;
  String? _currentLevel;

  FilteredCourseBloc({required CourseRepository courseRepository})
    : _courseRepository = courseRepository,
      super(FilteredCourseInitial()) {
    on<FilterCoursesByCategory>(_onFilterCoursesByCategory);
    on<FilterCoursesByLevel>(_onFilterCoursesByLevel);

    on<ClearFilteredCourses>(_onClearFilteredCourses);
  }

  Future<void> _onFilterCoursesByLevel(
    FilterCoursesByLevel event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentLevel = event.level;
      final courses = await _filterCourses();
      emit(
        FilteredCoursesLoaded(
          courses,
          categoryId: _currentCategoryId,
          level: _currentLevel,
        ),
      );
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  Future<void> _onFilterCoursesByCategory(
    FilterCoursesByCategory event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentCategoryId = event.categoryId;
      final courses = await _filterCourses();

      emit(
        FilteredCoursesLoaded(
          courses,
          categoryId: _currentCategoryId,
          level: _currentLevel,
        ),
      );
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

  Future<List<Course>> _filterCourses() async {
    // Get courses with category filter
    final courses = await _courseRepository.getCourses(
      categoryId: _currentCategoryId,
    );

    // apply level filter if set
    if (_currentLevel != null && _currentLevel != 'All Levels') {
      return courses.where((course) => course.level == _currentLevel).toList();
    }

    return courses;
  }
}
