import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/course.dart';

class CourseRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Course>> getCourses({String? categoryId}) async {
    try {
      Query query = _firestore.collection('courses');

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Course data is null');
        }
        return Course.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  Future<Course> getCourseDetail(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (!doc.exists) {
        throw Exception('Course not found');
      }

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Course data is null');
      }

      return Course.fromJson({...data, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to get course detail: $e');
    }
  }

  Future<Set<String>> getCompletedLessons(String courseID) async {
    try {
      final snapshot = await _firestore
          .collection('lesson_progress')
          .where('courseID', isEqualTo: courseID)
          .where('isCompleted', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['lessonId'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Failed to get completed lessons: $e');
    }
  }

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

  Future<void> updateCourse(Course course) async {
    try {
      // convert course to JSON
      final courseData = course.toJson();

      // Convert lessons to JSON
      final lessonsData = course.lessons
          .map((lesson) => lesson.toJson())
          .toList();

      // Update course document
      await _firestore.collection('courses').doc(course.id).update({
        ...courseData,
        'lessons': lessonsData,
      });
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  //delete course
  Future<void> deleteCourse(String courseId) async {
    try {
      // delete the course document
      await _firestore.collection('courses').doc(courseId).delete();

      // delete all enrollments for this course
      final enrollmentsSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .get();

      for (var doc in enrollmentsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}
