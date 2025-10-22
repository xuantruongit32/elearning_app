import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/review.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Review>> getCourseReviews(String courseId) async {
    try {
      final courseDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();
      if (!courseDoc.exists) {
        return [];
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('reviews')
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs.map((doc) {
        final data = doc.data();

        final reviewData = {...data, 'id': doc.id};

        return Review.fromJson(reviewData);
      }).toList();

      return reviews;
    } catch (e) {
      return [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      final docRef = _firestore.collection('reviews').doc();

      //create new review with generated Id
      final reviewWithId = Review(
        id: docRef.id,
        courseId: review.courseId,
        userId: review.userId,
        userName: review.userName,
        rating: review.rating,
        comment: review.comment,
        createdAt: review.createdAt,
      );
      // convert to JSON and save
      final reviewData = reviewWithId.toJson();
      // set the document data without the id field
      final dataToSave = Map<String, dynamic>.from(reviewData)..remove('id');
      await docRef.set(dataToSave);

      // update course rating and review count
      await _updateCourseRating(review.courseId);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  Future<void> _updateCourseRating(String courseId) async {
    try {
      // get all reviews for the course
      final reviews = await getCourseReviews(courseId);

      if (reviews.isEmpty) {
        // if no reviews, set rating to 0 and count to 0
        await _firestore.collection('courses').doc(courseId).update({
          'rating': 0.0,
          'reviewCount': 0,
        });
        return;
      }

      //calculate average rating
      double totalRating = 0;
      for (var review in reviews) {
        totalRating += review.rating;
      }
      final averageRating = totalRating / reviews.length;

      // update course document
      await _firestore.collection('courses').doc(courseId).update({
        'rating': averageRating,
        'reviewCount': reviews.length,
      });
    } catch (e) {
      //don't throw here as this is background operation
    }
  }

  Future<void> updateReview(Review review) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .update(review.toJson());
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }
}
