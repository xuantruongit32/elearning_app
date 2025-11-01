import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PerformanceCard extends StatelessWidget {
  final String courseName;
  final double completionRate;
  final int averageTimePerLesson;
  final double averageCompletionRate;

  const PerformanceCard({
    super.key,
    required this.courseName,
    required this.completionRate,
    required this.averageTimePerLesson,
    required this.averageCompletionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.assessment, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPerformanceMetric(
                  'Tỷ lệ hoàn thành khóa học',
                  completionRate,
                ),
                _buildTimeMetric(
                  'Thời gian trung bình mỗi bài học',
                  averageTimePerLesson,
                ),
                _buildPerformanceMetric(
                  'Tiến độ tổng thể',
                  averageCompletionRate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hiển thị các chỉ số theo phần trăm
  Widget _buildPerformanceMetric(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600])),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Hiển thị thời gian trung bình mỗi bài học theo phút
  Widget _buildTimeMetric(String label, int minutes) {
    final hours = (minutes / 60).floor();
    final mins = minutes % 60;
    final displayTime = hours > 0
        ? '${hours}h ${mins}p'
        : '${mins}p'; // ví dụ: "1h 20p" hoặc "45p"

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600])),
            Text(
              displayTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
