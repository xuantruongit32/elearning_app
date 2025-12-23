import 'package:elearning_app/controllers/admin_controller.dart';
import 'package:elearning_app/controllers/course_controller.dart';
import 'package:elearning_app/controllers/dashboard_controller.dart';
import 'package:elearning_app/controllers/payment_controller.dart';
import 'package:elearning_app/controllers/review_controller.dart';
import 'package:elearning_app/controllers/user_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Filter
          _buildFilterHeader(context, controller),
          const SizedBox(height: 24),

          //Stats Grid
          Obx(() {
            if (controller.isLoading.value)
              return const Center(child: CircularProgressIndicator());
            return GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              childAspectRatio: 1.4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  'Tổng doanh thu',
                  controller.formatCurrency(controller.totalRevenue.value),
                  Icons.monetization_on,
                  Colors.blue,
                  onTap: () {
                    final paymentController = Get.put(PaymentController());

                    DateTime now = DateTime.now();
                    DateTimeRange? targetRange;
                    Get.find<AdminController>().changeTab(4);

                    switch (controller.selectedFilter.value) {
                      case TimeFilter.today:
                        targetRange = DateTimeRange(start: now, end: now);
                        break;
                      case TimeFilter.thisWeek:
                        // Tìm ngày đầu tuần (Thứ 2)
                        DateTime startOfWeek = now.subtract(
                          Duration(days: now.weekday - 1),
                        );
                        targetRange = DateTimeRange(
                          start: startOfWeek,
                          end: now,
                        );
                        break;
                      case TimeFilter.thisMonth:
                        DateTime startOfMonth = DateTime(
                          now.year,
                          now.month,
                          1,
                        );
                        targetRange = DateTimeRange(
                          start: startOfMonth,
                          end: now,
                        );
                        break;
                      case TimeFilter.thisYear:
                        DateTime startOfYear = DateTime(now.year, 1, 1);
                        targetRange = DateTimeRange(
                          start: startOfYear,
                          end: now,
                        );
                        break;
                      case TimeFilter.custom:
                        targetRange = controller.dateRange.value;
                        break;
                      case TimeFilter.all:
                      default:
                        targetRange = null; //
                        break;
                    }

                    paymentController.dateRange.value = targetRange;

                    Get.rawSnackbar(
                      title: "Đã đồng bộ bộ lọc",
                      message:
                          "Đang hiển thị giao dịch theo bộ lọc từ Dashboard",
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                _buildStatCard(
                  'Lợi nhuận (30%)',
                  controller.formatCurrency(controller.profit.value),
                  Icons.account_balance_wallet,
                  Colors.green,
                ),
                _buildStatCard(
                  'Học viên Active',
                  '${controller.activeStudents.value}',
                  Icons.supervised_user_circle,
                  Colors.teal,
                ),
                _buildStatCard(
                  'Đăng ký mới',
                  '${controller.newStudents.value}',
                  Icons.person_add,
                  Colors.orange,
                  onTap: () {
                    final userController = Get.put(UserController());

                    // Reset tìm kiếm và chọn sắp xếp mới nhất
                    userController.searchQuery.value = '';
                    userController.selectedSort.value = UserSortOption.newest;

                    // Đồng bộ thời gian từ Dashboard
                    DateTimeRange? targetRange = _calculateDateRange(
                      controller,
                    );
                    userController.dateRange.value = targetRange;

                    Get.find<AdminController>().changeTab(3);
                  },
                ),
                _buildStatCard(
                  'Khóa học mới',
                  '${controller.createdCourses.value}',
                  Icons.book,
                  Colors.purple,
                  onTap: () {
                    final courseController = Get.put(CourseController());

                    courseController.searchQuery.value = '';
                    courseController.selectedCategory.value = 'all';
                    courseController.selectedSort.value =
                        CourseSortOption.newest;

                    Get.find<AdminController>().changeTab(2);
                  },
                ),
                _buildStatCard(
                  'Tổng Review',
                  '${controller.totalReviews.value}',
                  Icons.rate_review,
                  Colors.indigo,
                  onTap: () {
                    final reviewController = Get.put(ReviewController());

                    reviewController.searchQuery.value = '';
                    reviewController.isNewestFirst.value = true;
                    reviewController.selectedStarFilter.value = 0;

                    DateTimeRange? targetRange = _calculateDateRange(
                      controller,
                    );
                    if (targetRange != null) {
                      reviewController.startDate.value = targetRange.start;
                      reviewController.endDate.value = targetRange.end;
                    } else {
                      reviewController.clearDateFilter();
                    }

                    Get.find<AdminController>().changeTab(6);
                  },
                ),
                _buildStatCard(
                  'Rating TB',
                  controller.avgRating.value.toStringAsFixed(1),
                  Icons.star,
                  Colors.amber,
                ),
                _buildStatCard(
                  'Giảng viên mới',
                  '${controller.newTeachers.value}',
                  Icons.school,
                  Colors.pink,
                  onTap: () {
                    final userController = Get.put(UserController());

                    userController.searchQuery.value = '';
                    userController.selectedSort.value = UserSortOption.newest;

                    DateTimeRange? targetRange = _calculateDateRange(
                      controller,
                    );
                    userController.dateRange.value = targetRange;

                    Get.find<AdminController>().changeTab(3);
                  },
                ),
              ],
            );
          }),

          const SizedBox(height: 32),

          //Line Chart
          _buildChartSection(controller),
          const SizedBox(height: 32),

          //Top Courses & Categories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Courses
              Expanded(
                flex: 3,
                child: Obx(
                  () => _buildTopList(
                    title: 'Top Khóa học (Doanh thu)',
                    items: controller.topCourses,
                    currencyFormatter: controller.formatCurrency,
                    iconData: Icons.book,
                    iconColor: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Category Chart
              Expanded(flex: 2, child: _buildPieChartSection(controller)),
            ],
          ),
          const SizedBox(height: 24),

          // Top Students & Top Teachers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Students
              Expanded(
                child: Obx(
                  () => _buildTopList(
                    title: 'Top Học viên (Chi tiêu)',
                    items: controller.topStudents,
                    currencyFormatter: controller.formatCurrency,
                    iconData: Icons.person,
                    iconColor: Colors.blue,
                    showSubInfo: true,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Top Teachers
              Expanded(
                child: Obx(
                  () => _buildTopList(
                    title: 'Top Giảng viên (Doanh thu)',
                    items: controller.topTeachers,
                    currencyFormatter: controller.formatCurrency,
                    iconData: Icons.school,
                    iconColor: Colors.purple,
                    showSubInfo: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildTopList({
    required String title,
    required List<RevenueItem> items,
    required Function(double) currencyFormatter,
    required IconData iconData,
    required Color iconColor,
    bool showSubInfo = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Chưa có dữ liệu'),
            ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  // Rank Number
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index < 3 ? iconColor : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: index < 3 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showSubInfo &&
                            item.subInfo != null &&
                            item.subInfo!.isNotEmpty)
                          Text(
                            item.subInfo!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Amount
                  Text(
                    currencyFormatter(item.amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xu hướng doanh thu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 3,
            child: Obx(
              () => LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (val, _) => Text(
                          NumberFormat.compact().format(val),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: controller.maxY.value,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.chartSpots,
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tỷ trọng Danh mục',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: Obx(() {
              if (controller.topCategories.isEmpty)
                return const Center(child: Text('Chưa có dữ liệu'));
              return PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        controller.touchedIndex.value = -1;
                        return;
                      }
                      controller.touchedIndex.value =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: List.generate(controller.topCategories.length, (i) {
                    final isTouched = i == controller.touchedIndex.value;
                    final item = controller.topCategories[i];
                    return PieChartSectionData(
                      color: item.color,
                      value: item.amount,
                      title:
                          '${((item.amount / controller.totalRevenue.value) * 100).toStringAsFixed(0)}%',
                      radius: isTouched ? 60.0 : 50.0,
                      titleStyle: TextStyle(
                        fontSize: isTouched ? 16.0 : 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.topCategories
                  .map(
                    (item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(item.name, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader(
    BuildContext context,
    DashboardController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_list, color: Colors.grey),
          const SizedBox(width: 12),
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<TimeFilter>(
                value: controller.selectedFilter.value,
                items: const [
                  DropdownMenuItem(
                    value: TimeFilter.all,
                    child: Text('Toàn bộ'),
                  ),
                  DropdownMenuItem(
                    value: TimeFilter.today,
                    child: Text('Hôm nay'),
                  ),
                  DropdownMenuItem(
                    value: TimeFilter.thisWeek,
                    child: Text('Tuần này'),
                  ),
                  DropdownMenuItem(
                    value: TimeFilter.thisMonth,
                    child: Text('Tháng này'),
                  ),
                  DropdownMenuItem(
                    value: TimeFilter.thisYear,
                    child: Text('Năm nay'),
                  ),
                  DropdownMenuItem(
                    value: TimeFilter.custom,
                    child: Text('Tùy chọn...'),
                  ),
                ],
                onChanged: (val) => val == TimeFilter.custom
                    ? controller.pickDateRange(context)
                    : controller.updateFilter(val!),
              ),
            ),
          ),
          Obx(() {
            if (controller.selectedFilter.value == TimeFilter.custom &&
                controller.dateRange.value != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Chip(
                  label: Text(
                    '${DateFormat('dd/MM').format(controller.dateRange.value!.start)} - ${DateFormat('dd/MM').format(controller.dateRange.value!.end)}',
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 26),
                  if (onTap != null)
                    Tooltip(
                      message: "Xem chi tiết",
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    )
                  else if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTimeRange? _calculateDateRange(DashboardController controller) {
    DateTime now = DateTime.now();
    switch (controller.selectedFilter.value) {
      case TimeFilter.today:
        return DateTimeRange(start: now, end: now);
      case TimeFilter.thisWeek:
        // Tìm ngày đầu tuần (Thứ 2)
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return DateTimeRange(start: startOfWeek, end: now);
      case TimeFilter.thisMonth:
        // Ngày 1 của tháng hiện tại
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        return DateTimeRange(start: startOfMonth, end: now);
      case TimeFilter.thisYear:
        // Ngày 1/1 của năm hiện tại
        DateTime startOfYear = DateTime(now.year, 1, 1);
        return DateTimeRange(start: startOfYear, end: now);
      case TimeFilter.custom:
        return controller.dateRange.value;
      case TimeFilter.all:
      default:
        return null;
    }
  }
}
