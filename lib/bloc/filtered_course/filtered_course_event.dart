abstract class FilteredCourseEvent {}

class FilterCoursesByCategory extends FilteredCourseEvent {
  final String categoryId;

  FilterCoursesByCategory(this.categoryId);
}

class ClearFilteredCourses extends FilteredCourseEvent {}
