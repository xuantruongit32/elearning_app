import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String courseId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    try {
      DateTime parseDate(dynamic value) {
        if (value is Timestamp) {
          return value.toDate();
        } else if (value is String) {
          return DateTime.parse(value);
        } else if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value * 1000);
        }
        throw Exception('Invalid date format: $value');
      }

      //ensure we have all required fields
      if (json['courseId'] == null) throw Exception('courseId is required');
      if (json['userId'] == null) throw Exception('userId is required');
      if (json['userName'] == null) throw Exception('userName is required');
      if (json['rating'] == null) throw Exception('rating is required');
      if (json['comment'] == null) throw Exception('comment is required');
      if (json['createdAt'] == null) throw Exception('createdAt is required');

      return Review(
        id: json['id'] as String? ?? '',
        courseId: json['courseId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        rating: (json['rating'] as num).toDouble(),
        comment: json['comment'] as String,
        createdAt: parseDate(json['createdAt']),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  String toString() {
    return 'Review(id: $id, courseId: $courseId, userId: $userId, userName: $userName, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  Review copyWith({
    String? id,
    String? courseId,
    String? userId,
    String? userName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
