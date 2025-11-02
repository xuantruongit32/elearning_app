import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class QuizScoreCard extends StatelessWidget {
  final int percentage;
  final bool isPassed;

  const QuizScoreCard({
    super.key,
    required this.percentage,
    required this.isPassed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isPassed ? 'Chúc mừng bạn!' : 'Hãy tiếp tục luyện tập!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$percentage%',
            style: theme.textTheme.displayLarge?.copyWith(
              color: isPassed ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Điểm số',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
