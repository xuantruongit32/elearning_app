import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';
import 'package:flutter/material.dart';

class QuizStatsCard extends StatelessWidget {
  final Quiz quiz;
  final QuizAttempt attempt;

  const QuizStatsCard({super.key, required this.quiz, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final correctAnswers = quiz.questions
        .where((q) => attempt.answers[q.id] == q.correctOptionId)
        .length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống kê bài kiểm tra',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            theme,
            'Thời gian làm bài',
            '${(attempt.timeSpent ~/ 60)}p ${attempt.timeSpent % 60}g',
            Icons.timer,
          ),
          _buildStatRow(
            theme,
            'Câu trả lời đúng',
            '$correctAnswers/${quiz.questions.length}',
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
