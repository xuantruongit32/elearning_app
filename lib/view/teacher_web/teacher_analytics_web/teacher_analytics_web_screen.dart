import 'package:elearning_app/controllers/teacher_analytics_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/teacher_web/teacher_analytics_web/widgets/analytics_widgets_web.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherAnalyticsWebScreen extends StatelessWidget {
  const TeacherAnalyticsWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(TeacherAnalyticsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Thống kê & Hiệu quả giảng dạy',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.accent),
        elevation: 0,
        actions: [
          // Widget hiển thị khoảng thời gian đang chọn
          Obx(
            () => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.dateRangeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Dropdown chọn bộ lọc
          _buildFilterDropdown(controller, context),

          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.analyticsData.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final double padding = constraints.maxWidth > 1000 ? 32.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //OVERVIEW CARDS
                  WebOverviewSection(data: data), 

                  const SizedBox(height: 24),

                  //MAIN CHARTS
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: WebEnrollmentChart(
                            data: data,
                          ), 
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: WebEngagementPanel(
                            data: data,
                          ), 
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // REVENUE
                  WebRevenueSection(data: data), 

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFilterDropdown(
    TeacherAnalyticsController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<AnalyticsFilter>(
            value: controller.filterType.value,
            icon: const Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 16,
            ),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (AnalyticsFilter? val) {
              if (val == AnalyticsFilter.custom) {
                controller.pickCustomDate(context);
              } else if (val != null) {
                controller.updateDateRange(val);
              }
            },
            items: const [
              DropdownMenuItem(
                value: AnalyticsFilter.thisWeek,
                child: Text('Tuần này'),
              ),
              DropdownMenuItem(
                value: AnalyticsFilter.thisMonth,
                child: Text('Tháng này'),
              ),
              DropdownMenuItem(
                value: AnalyticsFilter.thisYear,
                child: Text('Năm nay'),
              ),
              DropdownMenuItem(
                value: AnalyticsFilter.custom,
                child: Text('Tùy chỉnh...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
