import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/review.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Review>> getCourseReviews(String courseId) async {
    try {
      // check if the collection exists
      final collectionRef = _firestore.collection('reviews');
      final collectionSnapshot = await collectionRef.limit(1).get();

      if (collectionSnapshot.docs.isEmpty) {
        // collection doesn't exist yet, return empty list
        return [];
      }

      final snapshot = await collectionRef
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Review data is null');
        }

        return Review.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add(review.toJson());
    } catch (e) {
      throw Exception('Failed to add review: $e');
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
