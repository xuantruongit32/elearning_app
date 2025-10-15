import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyCoursesState extends StatelessWidget {
  const EmptyCoursesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Courses Yet',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Create Your First Course'),
          ),
        ],
      ),
    );
  }
}
