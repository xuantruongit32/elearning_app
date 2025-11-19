import 'package:elearning_app/models/category_firestore.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/respositories/dashboard_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TimeFilter { all, today, thisWeek, thisMonth, thisYear, custom }

class RevenueItem {
  final String name;
  final double amount;
  final String? subInfo;
  final Color? color;

  RevenueItem(this.name, this.amount, {this.color, this.subInfo});
}

class DashboardController extends GetxController {
  final DashboardRepository _repo = DashboardRepository();

  var selectedFilter = TimeFilter.thisMonth.obs;
  var dateRange = Rx<DateTimeRange?>(null);
  var isLoading = true.obs;

  // Stats Variables
  var totalRevenue = 0.0.obs;
  var profit = 0.0.obs;
  var newStudents = 0.obs;
  var activeStudents = 0.obs;
  var newTeachers = 0.obs;
  var createdCourses = 0.obs;
  var totalReviews = 0.obs;
  var avgRating = 0.0.obs;

  // Chart Data
  var chartSpots = <FlSpot>[].obs;
  var maxY = 0.0.obs;

  // Top Lists
  var topCourses = <RevenueItem>[].obs;
  var topCategories = <RevenueItem>[].obs;
  var topStudents = <RevenueItem>[].obs;
  var topTeachers = <RevenueItem>[].obs;

  var touchedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    updateFilter(TimeFilter.thisMonth);
  }

  void updateFilter(TimeFilter filter) async {
    selectedFilter.value = filter;
    DateTime now = DateTime.now();
    DateTime? start;
    DateTime? end = now;

    switch (filter) {
      case TimeFilter.all:
        start = null;
        end = null;
        break;
      case TimeFilter.today:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case TimeFilter.thisWeek:
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        break;
      case TimeFilter.thisMonth:
        start = DateTime(now.year, now.month, 1);
        break;
      case TimeFilter.thisYear:
        start = DateTime(now.year, 1, 1);
        break;
      case TimeFilter.custom:
        if (dateRange.value != null) {
          start = dateRange.value!.start;
          end = dateRange.value!.end
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));
        }
        break;
    }
    await fetchData(start, end);
  }

  Future<void> fetchData(DateTime? start, DateTime? end) async {
    isLoading.value = true;
    try {
      final payments = await _repo.getPayments(start, end);
      final allUsers = await _repo.getUsers();
      final allCourses = await _repo.getCourses();
      final allCategories = await _repo.getCategories();

      // Doanh thu
      double revenue = 0;
      for (var p in payments) revenue += p.amount;
      totalRevenue.value = revenue;
      profit.value = revenue * 0.3;

      // User Stats
      var usersCreatedInRange = allUsers;
      if (start != null) {
        usersCreatedInRange = allUsers.where((u) {
          bool afterStart = u.createdAt.isAfter(start);
          bool beforeEnd = end == null || u.createdAt.isBefore(end);
          return afterStart && beforeEnd;
        }).toList();
      }
      newStudents.value = usersCreatedInRange
          .where((u) => u.role == UserRole.student)
          .length;
      newTeachers.value = usersCreatedInRange
          .where((u) => u.role == UserRole.teacher)
          .length;

      if (start == null) {
        activeStudents.value = allUsers
            .where((u) => u.role == UserRole.student)
            .length;
      } else {
        activeStudents.value = allUsers.where((u) {
          return u.role == UserRole.student &&
              u.lastLoginAt.isAfter(start) &&
              (end == null || u.lastLoginAt.isBefore(end));
        }).length;
      }

      //Course Stats
      if (start == null)
        createdCourses.value = allCourses.length;
      else
        createdCourses.value = allCourses
            .where(
              (c) =>
                  c.createdAt.isAfter(start) &&
                  (end == null || c.createdAt.isBefore(end)),
            )
            .length;

      int reviews = 0;
      double totalRatingSum = 0;
      int ratedCoursesCount = 0;
      for (var c in allCourses) {
        reviews += (c.reviewCount as num).toInt();
        if (c.reviewCount > 0) {
          totalRatingSum += c.rating;
          ratedCoursesCount++;
        }
      }
      totalReviews.value = reviews;
      avgRating.value = ratedCoursesCount > 0
          ? totalRatingSum / ratedCoursesCount
          : 0.0;

      // Chart
      _prepareChartData(payments, start, end);

      // TOP CHARTS
      _calculateRevenueBreakdown(payments, allCourses, allCategories, allUsers);
    } catch (e) {
      print("Error dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateRevenueBreakdown(
    List<SimplePayment> payments,
    List<Course> courses,
    List<CategoryFirestoreModel> categories,
    List<UserModel> users,
  ) {
    //Tạo Map lookup
    Map<String, Course> courseMap = {for (var c in courses) c.id: c};
    Map<String, String> categoryNameMap = {
      for (var c in categories) c.id: c.name,
    };
    Map<String, UserModel> userMap = {
      for (var u in users) u.uid: u,
    }; // Map UID -> User

    //Biến tích lũy
    Map<String, double> revenueByCourse = {};
    Map<String, double> revenueByCategory = {};
    Map<String, double> revenueByStudent = {};
    Map<String, double> revenueByTeacher = {};

    //Loop 1 lần duy nhất qua payments
    for (var p in payments) {
      // Cộng Course
      revenueByCourse[p.courseId] =
          (revenueByCourse[p.courseId] ?? 0) + p.amount;

      // Cộng Category
      final course = courseMap[p.courseId];
      if (course != null) {
        revenueByCategory[course.categoryId] =
            (revenueByCategory[course.categoryId] ?? 0) + p.amount;
      } else {
        revenueByCategory['unknown'] =
            (revenueByCategory['unknown'] ?? 0) + p.amount;
      }

      //Học viên chi tiền
      revenueByStudent[p.studentId] =
          (revenueByStudent[p.studentId] ?? 0) + p.amount;

      // Giảng viên nhận doanh thu
      revenueByTeacher[p.teacherId] =
          (revenueByTeacher[p.teacherId] ?? 0) + p.amount;
    }

    //Top Courses
    List<RevenueItem> courseList = [];
    revenueByCourse.forEach((id, amount) {
      final title = courseMap[id]?.title ?? 'Khóa học đã xóa ($id)';
      courseList.add(RevenueItem(title, amount));
    });
    courseList.sort((a, b) => b.amount.compareTo(a.amount));
    topCourses.assignAll(courseList.take(5).toList()); // Top 5

    //Top Categories
    List<RevenueItem> catList = [];
    List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];
    int cIdx = 0;
    revenueByCategory.forEach((id, amount) {
      String name = id == 'unknown' ? 'Khác' : (categoryNameMap[id] ?? 'Lỗi');
      catList.add(
        RevenueItem(name, amount, color: colors[cIdx % colors.length]),
      );
      cIdx++;
    });
    catList.sort((a, b) => b.amount.compareTo(a.amount));
    topCategories.assignAll(catList);

    //Top Students
    List<RevenueItem> studentList = [];
    revenueByStudent.forEach((uid, amount) {
      final user = userMap[uid];
      final name = user?.fullName ?? 'Unknown ($uid)';
      final email = user?.email ?? '';
      studentList.add(RevenueItem(name, amount, subInfo: email));
    });
    studentList.sort((a, b) => b.amount.compareTo(a.amount));
    topStudents.assignAll(studentList.take(5).toList()); // Top 5

    //Top Teachers
    List<RevenueItem> teacherList = [];
    revenueByTeacher.forEach((uid, amount) {
      final user = userMap[uid];
      final name = user?.fullName ?? 'Unknown ($uid)';
      final email = user?.email ?? '';
      teacherList.add(RevenueItem(name, amount, subInfo: email));
    });
    teacherList.sort((a, b) => b.amount.compareTo(a.amount));
    topTeachers.assignAll(teacherList.take(5).toList()); // Top 5
  }

  void _prepareChartData(
    List<SimplePayment> payments,
    DateTime? start,
    DateTime? end,
  ) {
    Map<int, double> dailyRevenue = {};
    DateTime baseDate =
        start ??
        (payments.isNotEmpty ? payments.last.date.toDate() : DateTime.now());
    int days = end != null ? end.difference(baseDate).inDays + 1 : 30;
    if (days > 30) days = 30;

    for (int i = 0; i < days; i++) dailyRevenue[i] = 0.0;
    double maxVal = 0;
    for (var p in payments) {
      DateTime date = p.date.toDate();
      int index = date.difference(baseDate).inDays;
      if (index >= 0 && index < days) {
        dailyRevenue[index] = (dailyRevenue[index] ?? 0) + p.amount;
        if (dailyRevenue[index]! > maxVal) maxVal = dailyRevenue[index]!;
      }
    }
    List<FlSpot> spots = [];
    final sortedKeys = dailyRevenue.keys.toList()..sort();
    for (var key in sortedKeys) {
      spots.add(FlSpot(key.toDouble(), dailyRevenue[key]!));
    }
    chartSpots.assignAll(spots);
    maxY.value = maxVal == 0 ? 1000000 : maxVal * 1.2;
  }

  Future<void> pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange.value,
    );
    if (picked != null) {
      dateRange.value = picked;
      updateFilter(TimeFilter.custom);
    }
  }

  String formatCurrency(double amount) =>
      NumberFormat.compactCurrency(locale: 'vi_VN', symbol: 'đ').format(amount);
}
