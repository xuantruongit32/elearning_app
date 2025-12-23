import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class QuizAttemptAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String formattedTime;
  final VoidCallback onSubmit;

  const QuizAttemptAppBar({
    super.key,
    required this.formattedTime,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.accent),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.accent, size: 20),
            const SizedBox(width: 8),
            Text(
              formattedTime,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: onSubmit,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.accent.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Nộp bài',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
