import 'dart:async';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/widgets/quiz_attempt_app_bar.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/widgets/quiz_navigation_bar.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/widgets/quiz_question_page.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/widgets/quiz_submit_dialog.dart';
import 'package:elearning_app/view/quiz/quiz_result/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    if (_pageController != null) {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    }
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _submitQuiz();
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
    Get.off(() => QuizResultScreen(attempt: currentAttempt!, quiz: quiz));
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

  void _selectAnswer(String questionId, String optionId) {
    setState(() {
      selectedAnswers[questionId] = optionId;
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: QuizAttemptAppBar(
        formattedTime: formattedTime,
        onSubmit: () => _showSubmitDialog(context),
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: quiz.questions.length,
        itemBuilder: (BuildContext context, int index) => QuizQuestionPage(
          questionNumber: index + 1,
          totalQuestions: quiz.questions.length,
          question: quiz.questions[index],
          selectedOptionId: selectedAnswers[quiz.questions[index].id],
          onOptionSelected: (optionId) =>
              _selectAnswer(quiz.questions[index].id, optionId),
        ),
      ),
      bottomNavigationBar: QuizNavigationBar(
        theme: theme,
        onPreviousPressed: _currentPage > 0
            ? () => _navigateToPage(_currentPage - 1)
            : null,
        onNextPressed: _currentPage < quiz.questions.length - 1
            ? () => _navigateToPage(_currentPage + 1)
            : null,
        isLastPage: _currentPage == quiz.questions.length - 1,
      ),
    );
  }

  Future<void> _showSubmitDialog(BuildContext context) async {
    final score = _calculateScore();
    currentAttempt = QuizAttempt(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      quizId: quiz.id,
      userId: 'current user id',
      answers: selectedAnswers,
      score: score,
      startedAt: DateTime.now().subtract(
        Duration(seconds: quiz.timeLimit * 60 - remainingSeconds),
      ),
      timeSpent: quiz.timeLimit * 60 - remainingSeconds,
      completedAt: DateTime.now(),
    );

    // save attempt
    DummyDataService.saveQuizAttempt(currentAttempt!);

    return showDialog(
      context: context,
      builder: (context) =>
          QuizSubmitDialog(attempt: currentAttempt!, quiz: quiz),
    );
  }
}
