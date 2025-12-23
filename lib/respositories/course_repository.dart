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

  Future<Set<String>> getCompletedLessons(
    String courseID,
    String studentId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseID)
          .where('studentId', isEqualTo: studentId)
          .where('isCompleted', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['lessonId'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Failed to get completed lessons: $e');
    }
  }

  Future<void> updateCourseProgress(String courseId, String studentId) async {
    try {
      // Get the course to count total lessons
      final course = await getCourseDetail(courseId);
      final totalLessons = course.lessons.length;

      // get completed lessons
      final completedLessons = await getCompletedLessons(courseId, studentId);

      // calculate progress percentage
      final progress = (completedLessons.length / totalLessons) * 100;

      // get enrollment document
      final enrollmentSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (enrollmentSnapshot.docs.isNotEmpty) {
        // update progress in enrollment document
        await _firestore
            .collection('enrollments')
            .doc(enrollmentSnapshot.docs.first.id)
            .update({
              'progress': progress,
              'updatedAt': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      throw Exception('Failed to update course progress: $e');
    }
  }

  Future<void> enrollCourse(String userId, String courseId) async {
    try {
      await _firestore.collection('enrollments').add({
        'studentId': userId,
        'courseId': courseId,
        'enrolledAt': FieldValue.serverTimestamp(),
        'progress': 0,
      });
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  Future<double> getCourseProgress(String courseId, String studentId) async {
    try {
      final enrollmentSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (enrollmentSnapshot.docs.isEmpty) {
        return 0.0;
      }

      return (enrollmentSnapshot.docs.first.data()['progress'] as num)
          .toDouble();
    } catch (e) {
      throw Exception('Failed to get course progress: $e');
    }
  }

  Future<void> markLessonAsCompleted(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      // check if progress document already exists
      final existingProgress = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingProgress.docs.isEmpty) {
        // create new progress document
        await _firestore.collection('lesson_student_progress').add({
          'courseId': courseId,
          'lessonId': lessonId,
          'studentId': studentId,
          'isCompleted': true,
          'isLocked': false,
          'completedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // update existing progress document
        await _firestore
            .collection('lesson_student_progress')
            .doc(existingProgress.docs.first.id)
            .update({
              'isCompleted': true,
              'completedAt': FieldValue.serverTimestamp(),
            });
      }

      //update course progress after making lesson as completed
      await updateCourseProgress(courseId, studentId);
    } catch (e) {
      throw Exception('Failed to mark lesson as completed: $e');
    }
  }

  Future<void> unlockLesson(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      // check if progress document already
      final existingProgress = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingProgress.docs.isEmpty) {
        // create new progress document
        await _firestore.collection('lesson_student_progress').add({
          'courseId': courseId,
          'lessonId': lessonId,
          'studentId': studentId,
          'isCompleted': false,
          'isLocked': false,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
      } else {
        //update existing progress document
        await _firestore
            .collection('lesson_student_progress')
            .doc(existingProgress.docs.first.id)
            .update({
              'isLocked': false,
              'unlockedAt': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      throw Exception('Failed to unlock lesson: $e');
    }
  }

  Future<bool> isLessonUnlocked(
    String courseId,
    String lessonId,
    String studentId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('lesson_student_progress')
          .where('courseId', isEqualTo: courseId)
          .where('lessonId', isEqualTo: lessonId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isEmpty) {
        // if no progress record exists, first lesson is unlocked by default
        final course = await getCourseDetail(courseId);
        return course.lessons.first.id == lessonId;
      }
      final isLocked = snapshot.docs.first.data()['isLocked'] as bool? ?? true;

      return !isLocked;
    } catch (e) {
      throw Exception('Failed to check lesson unlock status: $e');
    }
  }

  Future<void> enrollInCourse(
    String courseId,
    String studentId, {
    bool isPremium = false,
  }) async {
    try {
      // check if already enrolled
      final existingEnrollment = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existingEnrollment.docs.isEmpty) {
        // new enrollment
        await _firestore.collection('enrollments').add({
          'courseId': courseId,
          'studentId': studentId,
          'enrolledAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isPremium': isPremium,
          'progress': 0.0,
        });

        await _firestore.collection('courses').doc(courseId).update({
          'enrollmentCount': FieldValue.increment(1),
        });

        //first lesson
        final course = await getCourseDetail(courseId);
        if (course.lessons.isNotEmpty) {
          await unlockLesson(courseId, course.lessons.first.id, studentId);
        }
      }
    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  Future<bool> isEnrolled(String courseId, String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check enrollment status: $e');
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

  Future<bool> isCourseCompleted(String courseId, String studentId) async {
    try {
      // get the course to count total lessons
      final course = await getCourseDetail(courseId);
      final totalLessons = course.lessons.length;

      // Get completed lessons
      final completedLessons = await getCompletedLessons(courseId, studentId);

      // course is completed if all lessons are completed
      return completedLessons.length == totalLessons;
    } catch (e) {
      throw Exception('Failed to check course completion status: $e');
    }
  }

  Future<Set<String>> getEnrolledCourseIds(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('enrollments')
          .where('studentId', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isEmpty) {
        return <String>{};
      }

      return snapshot.docs
          .map((doc) => doc.data()['courseId'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Failed to get enrolled course IDs: $e');
    }
  }
}
