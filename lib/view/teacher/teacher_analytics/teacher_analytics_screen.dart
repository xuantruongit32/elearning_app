import 'package:elearning_app/controllers/teacher_analytics_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/teacher/teacher_analytics/widgets/analytics_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherAnalyticsScreen extends StatelessWidget {
  const TeacherAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherAnalyticsController());

    return Scaffold(
      backgroundColor: AppColors.lightBackground, 
      appBar: AppBar(
        title: const Text(
          'Thống kê',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.accent),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  controller.dateRangeText.length > 15
                      ? 'Tùy chỉnh' // Nếu text dài quá thì hiện gọn
                      : controller.dateRangeText,
                  // FIX MÀU: Chuyển sang màu trắng (Colors.white) và in đậm (w600) cho dễ đọc trên nền AppColors.primary
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Nút Filter
          PopupMenuButton<AnalyticsFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (AnalyticsFilter val) {
              if (val == AnalyticsFilter.custom) {
                controller.pickCustomDate(context);
              } else {
                controller.updateDateRange(val);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AnalyticsFilter.thisWeek,
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_week, size: 20),
                    SizedBox(width: 8),
                    Text('Tuần này'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AnalyticsFilter.thisMonth,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 20),
                    SizedBox(width: 8),
                    Text('Tháng này'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AnalyticsFilter.thisYear,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    SizedBox(width: 8),
                    Text('Năm nay'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AnalyticsFilter.custom,
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 20),
                    SizedBox(width: 8),
                    Text('Tùy chỉnh...'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.analyticsData.value;

        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Overview Grid 
                MobileOverviewGrid(data: data),

                const SizedBox(height: 24),

                //Chart Đăng ký
                MobileEnrollmentChart(data: data),

                const SizedBox(height: 24),

                //Engagement Widget
                MobileEngagementCard(data: data),

                const SizedBox(height: 24),

                //Revenue & Top Courses
                MobileRevenueCard(data: data),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}
