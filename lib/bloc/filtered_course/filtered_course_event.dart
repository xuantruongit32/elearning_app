abstract class FilteredCourseEvent {}

class FilterCoursesByCategory extends FilteredCourseEvent {
  final String categoryId;

  FilterCoursesByCategory(this.categoryId);
}

class FilterCoursesByLevel extends FilteredCourseEvent {
  final String level;

  FilterCoursesByLevel(this.level);
}

class SearchCourses extends FilteredCourseEvent {
  final String query;

  SearchCourses(this.query);
}

class ClearFilteredCourses extends FilteredCourseEvent {}
