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

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    courseId: json['courseId'],
    userId: json['userId'],
    userName: json['userName'],
    rating: json['rating'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseID': courseId,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };
}
