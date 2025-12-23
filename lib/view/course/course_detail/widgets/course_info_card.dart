import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:flutter/material.dart';

class CourseInfoCard extends StatelessWidget {
  final Course course;
  const CourseInfoCard({super.key, required this.course});
  String _translateLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'Cơ bản';
      case 'inter':
      case 'intermediate':
        return 'Trung cấp';
      case 'advanced':
        return 'Nâng cao';
      default:
        return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayLevel = _translateLevel(course.level);
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  Icons.people,
                  '${course.enrollmentCount}+',
                  'Học viên',
                ),
                _buildInfoItem(
                  context,
                  Icons.star,
                  course.rating.toString(),
                  '${course.reviewCount} Reviews',
                ),
                _buildInfoItem(
                  context,
                  Icons.library_books,
                  '${course.lessons.length}',
                  'Bài học',
                ),
                _buildInfoItem(
                  context,
                  Icons.signal_cellular_alt,
                  displayLevel,
                  'Trình độ',
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (course.requirements.isNotEmpty) ...[
              _buildSectionTitle(context, 'Yêu cầu'),
              const SizedBox(height: 8),
              ...course.requirements.map(
                (requirement) => _buildRequirementItem(context, requirement),
              ),
              const SizedBox(height: 8),
            ],
            if (course.whatYouWillLearn.isNotEmpty) ...[
              _buildSectionTitle(context, 'Bạn sẽ học được gì'),
              const SizedBox(height: 8),
              ...course.whatYouWillLearn.map(
                (item) => _buildLearningItem(context, item),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRequirementItem(BuildContext context, String requirement) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Expanded(child: Text(requirement, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildLearningItem(BuildContext context, String item) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(item, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
