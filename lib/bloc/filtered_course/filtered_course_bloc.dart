import 'package:elearning_app/bloc/auth/auth_bloc.dart'; // <-- THÊM IMPORT NÀY
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_state.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredCourseBloc
    extends Bloc<FilteredCourseEvent, FilteredCourseState> {
  final CourseRepository _courseRepository;
  final AuthBloc _authBloc; // <-- THÊM DÒNG NÀY
  String? _currentCategoryId;
  String? _currentLevel;
  String? _currentSearchQuery;

  FilteredCourseBloc({
    required CourseRepository courseRepository,
    required AuthBloc authBloc, // <-- THÊM DÒNG NÀY
  }) : _courseRepository = courseRepository,
       _authBloc = authBloc, // <-- THÊM DÒNG NÀY
       super(FilteredCourseInitial()) {
    on<FilterCoursesByCategory>(_onFilterCoursesByCategory);
    on<FilterCoursesByLevel>(_onFilterCoursesByLevel);
    on<SearchCourses>(_onSearchCourses);
    on<ClearFilteredCourses>(_onClearFilteredCourses);
  }

  Future<void> _onSearchCourses(
    SearchCourses event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());

    try {
      _currentSearchQuery = event.query.trim();

      final userId = _authBloc.state.userModel?.uid;
      final results = await Future.wait([
        _filterCourses(), 
        if (userId != null) 
          _courseRepository.getEnrolledCourseIds(userId)
        else
          Future.value(<String>{}), 
      ]);

      final courses = results[0] as List<Course>;
      final enrolledIds = results[1] as Set<String>;

      emit(
        FilteredCoursesLoaded(
          courses,
          enrolledCourseIds: enrolledIds,
          categoryId: _currentCategoryId,
          level: _currentLevel,
          searchQuery: _currentSearchQuery,
        ),
      );
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  Future<void> _onFilterCoursesByLevel(
    FilterCoursesByLevel event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentLevel = event.level;
      _currentSearchQuery = null; 
      final userId = _authBloc.state.userModel?.uid;
      final results = await Future.wait([
        _filterCourses(), 
        if (userId != null) 
          _courseRepository.getEnrolledCourseIds(userId)
        else
          Future.value(<String>{}),
      ]);

      final courses = results[0] as List<Course>;
      final enrolledIds = results[1] as Set<String>;

      emit(
        FilteredCoursesLoaded(
          courses,
          enrolledCourseIds: enrolledIds,
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
      // Reset tất cả filter khi chọn category mới
      _currentCategoryId = event.categoryId;
      _currentLevel = null;
      _currentSearchQuery = null;

      final userId = _authBloc.state.userModel?.uid;
      final results = await Future.wait([
        _filterCourses(), 
        if (userId != null) 
          _courseRepository.getEnrolledCourseIds(userId)
        else
          Future.value(<String>{}),
      ]);

      final courses = results[0] as List<Course>;
      final enrolledIds = results[1] as Set<String>;

      emit(
        FilteredCoursesLoaded(
          courses,
          enrolledCourseIds: enrolledIds, 
          level: _currentLevel,
          searchQuery: _currentSearchQuery, 
        ),
      );
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  Future<void> _onClearFilteredCourses(
    ClearFilteredCourses event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentLevel = null;

      final userId = _authBloc.state.userModel?.uid;
      final results = await Future.wait([
        _filterCourses(), 
        if (userId != null) 
          _courseRepository.getEnrolledCourseIds(userId)
        else
          Future.value(<String>{}),
      ]);

      final courses = results[0] as List<Course>;
      final enrolledIds = results[1] as Set<String>;
    
      if (_currentCategoryId != null) {
        emit(
          FilteredCoursesLoaded(
            courses,
            enrolledCourseIds: enrolledIds, 
            categoryId: _currentCategoryId,
            level: _currentLevel,
            searchQuery: _currentSearchQuery,
          ),
        );
      } else {
        
        emit(
          FilteredCoursesLoaded(
            courses, 
            enrolledCourseIds: enrolledIds, 
          ),
        );
      }
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  Future<List<Course>> _filterCourses() async {
    // Get courses with category filter
    final courses = await _courseRepository.getCourses(
      categoryId: _currentCategoryId,
    );

    var filteredCourses = courses;

    // apply level filter if set
    if (_currentLevel != null && _currentLevel != 'All Levels') {
      filteredCourses = filteredCourses
          .where((course) => course.level == _currentLevel)
          .toList();
    }

    //apply search filter if set
    if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) {
      final query = _currentSearchQuery!.toLowerCase();
      filteredCourses = filteredCourses
          .where(
            (course) =>
                course.title.toLowerCase().contains(query) ||
                course.description.toLowerCase().contains(query),
          )
          .toList();
    }

    return filteredCourses;
  }
}
