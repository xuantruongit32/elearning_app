abstract class FilteredCourseEvent {}

class FilterCoursesByCategory extends FilteredCourseEvent {
  final String categoryId;

  FilterCoursesByCategory(this.categoryId);
}

class FilterCoursesByLevel extends FilteredCourseEvent {
  final String level;

  FilterCoursesByLevel(this.level);
}

class ClearFilteredCourses extends FilteredCourseEvent {}
