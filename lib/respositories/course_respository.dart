import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/course.dart';

class CourseRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createCourse(Course course) async {
    try {
      final courseData = course.toJson();
      final lessonsData = course.lessons
          .map((lesson) => lesson.toJson())
          .toList();

      await _firestore.collection('courses').doc(course.id).set({
        ...courseData,
        'lessons': lessonsData,
      });
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<List<Course>> getInstructorCourses(String instructorId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .where('instructorId', isEqualTo: instructorId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Course data is null');
        }
        return Course.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to get instructor courses: $e');
    }
  }
}
