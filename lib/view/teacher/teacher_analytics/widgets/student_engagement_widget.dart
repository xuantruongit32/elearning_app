import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';

class StudentEngagementWidget extends StatelessWidget {
  final String instructorId;
  const StudentEngagementWidget({super.key, required this.instructorId});

  @override
  Widget build(BuildContext context) {
    final stats = DummyDataService.getTeacherStats(instructorId);
    final engagement = stats.studentEngagement;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Engagement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildEngagementMetric(
            'Average Completion Rate',
            '${(engagement.averageCompletionRate * 100).toInt()}%',
            Icons.school,
          ),
          Divider(height: 32, color: Colors.grey.shade300),
          _buildEngagementMetric(
            'Average Time per Lesson',
            '${engagement.averageTimePerLesson} mins ',
            Icons.timer,
          ),
          Divider(height: 32, color: Colors.grey.shade300),

          _buildEngagementMetric(
            'Active Students this Week',
            engagement.activeStudentsThisWeek.toString(),
            Icons.people,
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetric(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
