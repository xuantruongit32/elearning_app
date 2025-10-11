import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CourseFilterDialog extends StatelessWidget {
  const CourseFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Courses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterOption(context, 'All levels', true),
          _buildFilterOption(context, 'Beginner', false),
          _buildFilterOption(context, 'Intermediate', false),
          _buildFilterOption(context, 'Advanced', false),

          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                ),
              ),
            ],
            
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
