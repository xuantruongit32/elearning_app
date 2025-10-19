class PrerequisiteCourse {
  final String id;
  final String title;

  PrerequisiteCourse({required this.id, required this.title});

  factory PrerequisiteCourse.fromMap(Map<String, dynamic> map) {
    return PrerequisiteCourse(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  Map<String, String> toMap() {
    return {'id': id, 'title': title};
  }
}
