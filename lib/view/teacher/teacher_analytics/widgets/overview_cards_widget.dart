import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewCardsWidget extends StatelessWidget {
  final String instructorId;
  const OverviewCardsWidget({super.key, required this.instructorId});

  @override
  Widget build(BuildContext context) {
    final stats = DummyDataService.getTeacherStats(instructorId);

    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Tổng số học viên',
          '${stats.totalStudents}',
          Icons.people,
        ),
        _buildStatCard(
          'Khóa học hoạt động',
          '${stats.activeCourses}',
          Icons.school,
        ),
        _buildStatCard(
          'Tổng doanh thu',
          formatCurrency.format(stats.totalRevenue * 100),
          Icons.attach_money,
        ),
        _buildStatCard(
          'Đánh giá trung bình',
          stats.averageRating.toString(),
          Icons.star,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final valueFontSize = maxWidth * 0.15;
        final titleFontSize = maxWidth * 0.08;
        final iconSize = maxHeight * 0.25;
        return Container(
          padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: iconSize),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
