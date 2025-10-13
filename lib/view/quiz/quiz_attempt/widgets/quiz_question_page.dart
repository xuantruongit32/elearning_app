import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/question.dart';
import 'package:flutter/material.dart';

class QuizQuestionPage extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final Question question;
  final String? selectedOptionId;
  final Function(String) onOptionSelected;

  const QuizQuestionPage({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.question,
    this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Question $questionNumber of $totalQuestions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
