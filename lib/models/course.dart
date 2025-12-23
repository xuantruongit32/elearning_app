import 'package:elearning_app/models/lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String instructorId;
  final String categoryId;
  final double price;
  final List<Lesson> lessons;
  final double rating;
  final int reviewCount;
  final int enrollmentCount;
  final String level;
  final List<String> requirements;
  final List<String> whatYouWillLearn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPremium;
  final List<String> prerequisites;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.instructorId,
    required this.categoryId,
    required this.price,
    required this.lessons,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.enrollmentCount = 0,
    required this.level,
    required this.requirements,
    required this.whatYouWillLearn,
    required this.createdAt,
    required this.updatedAt,
    this.isPremium = false,
    this.prerequisites = const [],
  });
  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    instructorId: json['instructorId'],
    categoryId: json['categoryId'],
    price: json['price'].toDouble(),
    lessons: (json['lessons'] as List)
        .map((lesson) => Lesson.fromJson(lesson))
        .toList(),
    rating: json['rating']?.toDouble() ?? 0.0,
    reviewCount: json['reviewCount'] ?? 0,
    enrollmentCount: json['enrollmentCount'] ?? 0,
    level: json['level'],
    requirements: List<String>.from(json['requirements']),
    whatYouWillLearn: List<String>.from(json['whatYouWillLearn']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    isPremium: json['isPremium'] ?? false,
    prerequisites: List<String>.from(json['prerequisite'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'instructorId': instructorId,
    'categoryId': categoryId,
    'price': price,
    'lessons': lessons.map((lesson) => lesson?.toJson()).toList(),
    'rating': rating,
    'reviewCount': reviewCount,
    'enrollmentCount': enrollmentCount,
    'level': level,
    'requirements': requirements,
    'whatYouWillLearn': whatYouWillLearn,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isPremium': isPremium,
    'prerequisite': prerequisites,
  };
}
