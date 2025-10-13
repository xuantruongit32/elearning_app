import 'dart:async';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;
  const QuizAttemptScreen({super.key, required this.quizId});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late final Quiz quiz;
  late final PageController _pageController;
  int _currentPage = 0;
  Map<String, String> selectedAnswers = {};
  int remainingSeconds = 0;
  Timer? _timer;
  QuizAttempt? currentAttempt;

  @override
  void initState() {
    super.initState();
    quiz = DummyDataService.getQuizById(widget.quizId);
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
    remainingSeconds = quiz.timeLimit * 60;
    _startTimer();
  }

  void _onPageChanged() {
    if (_pageController != null) {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _submitQuiz(); // Gọi phương thức đã được định nghĩa
      }
    });
  }

  void _submitQuiz() {
    _timer?.cancel();
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      quizId: quiz.id,
      userId: 'current user is',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now().subtract(
        Duration(seconds: quiz.timeLimit * 60 - remainingSeconds),
      ),
      completedAt: DateTime.now(),
      timeSpent: quiz.timeLimit * 60 - remainingSeconds,
    );

    DummyDataService.saveQuizAttempt(currentAttempt!);

    //navigate to quiz result
  }

  int _calculateScore() {
    int score = 0;
    for (final question in quiz.questions) {
      if (selectedAnswers[question.id] == question.correctOptionId) {
        score += question.points;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return const Placeholder();
  }
}
