class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final Map<String, String> answers; // questionId : selectedOptionId
  final int score;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int timeSpent; //second

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.answers,
    required this.score,
    required this.startedAt,
    this.completedAt,
    required this.timeSpent,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
  return QuizAttempt(
    id: json['id'] ?? '',
    quizId: json['quizId'] ?? '',
    userId: json['userId'] ?? '',
    answers: Map<String, String>.from(json['answers'] ?? {}),
    score: json['score'] ?? 0,
    startedAt: DateTime.parse(json['startedAt']),
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    timeSpent: json['timeSpent'] ?? 0,
  ); // QuizAttempt
}

Map<String, dynamic> toJson() {
  return {
    'quizId': quizId,
    'userId': userId,
    'answers': answers,
    'score': score,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'timeSpent' : timeSpent,
  };
}
}
