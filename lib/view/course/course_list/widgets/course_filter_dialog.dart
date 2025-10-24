import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CourseFilterDialog extends StatefulWidget {
  final Function(String) onLevelSelected;
  final String? initialLevel;
  const CourseFilterDialog({
    super.key,
    required this.onLevelSelected,
    this.initialLevel,
  });

  @override
  State<CourseFilterDialog> createState() => _CourseFilterDialogState();
}

class _CourseFilterDialogState extends State<CourseFilterDialog> {
  late String _selectedLevel;
  final List<String> _levels = [
    'All Levels',
    'Beginners',
    'Intermediae',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel ?? 'All Levels';
  }

  void _handleApplyFilter () {
  widget.onLevelSelected(_selectedLevel);
  Navigator.pop(context);
}

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
          ..._levels.map(_buildFilterOption),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _handleResetFilter,
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: ()  _handleApplyFilter,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String level) {
    final isSelected = _selectedLevel == level;
    return ListTile(
      title: Text(level),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
    );
  }
}
