import 'package:elearning_app/models/question.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final int timeLimit;
  final List<Question> questions;
  final DateTime createdAt;
  final bool isActive;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.questions,
    required this.createdAt,
    this.isActive = true,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timeLimit: json['timeLimit'] ?? 30,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromMap(q))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
