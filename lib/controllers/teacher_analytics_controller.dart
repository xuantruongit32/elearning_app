import 'package:elearning_app/respositories/teacher_analytics_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum AnalyticsFilter { thisWeek, thisMonth, thisYear, custom }

class TeacherAnalyticsController extends GetxController {
  final TeacherAnalyticsRepository _repo = TeacherAnalyticsRepository();

  var filterType = AnalyticsFilter.thisMonth.obs;
  var startDate = Rx<DateTime>(DateTime.now());
  var endDate = Rx<DateTime>(DateTime.now());
  var isLoading = true.obs;
  var analyticsData = TeacherAnalyticsData().obs;

  final String? teacherId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    if (teacherId != null) {
      updateDateRange(AnalyticsFilter.thisMonth);
    }
  }

  void updateDateRange(AnalyticsFilter filter, {DateTimeRange? customRange}) {
    filterType.value = filter;
    final now = DateTime.now();

    switch (filter) {
      case AnalyticsFilter.thisWeek:
        startDate.value = now.subtract(Duration(days: now.weekday - 1));
        startDate.value = DateTime(
          startDate.value.year,
          startDate.value.month,
          startDate.value.day,
        );
        endDate.value = now;
        break;
      case AnalyticsFilter.thisMonth:
        startDate.value = DateTime(now.year, now.month, 1);
        endDate.value = now;
        break;
      case AnalyticsFilter.thisYear:
        startDate.value = DateTime(now.year, 1, 1);
        endDate.value = now;
        break;
      case AnalyticsFilter.custom:
        if (customRange != null) {
          startDate.value = customRange.start;
          endDate.value = customRange.end;
        }
        break;
    }

    fetchData();
  }

  Future<void> fetchData() async {
    if (teacherId == null) return;

    try {
      isLoading.value = true;
      final endOfDay = DateTime(
        endDate.value.year,
        endDate.value.month,
        endDate.value.day,
        23,
        59,
        59,
      );

      final data = await _repo.getAnalytics(
        teacherId!,
        startDate.value,
        endOfDay,
      );
      analyticsData.value = data;
    } catch (e) {
      print("Lỗi controller: $e");
      // Đã bỏ Snackbar để tránh lỗi crash overlay trên Web.
      // Dữ liệu lỗi sẽ chỉ in ra log, UI sẽ giữ nguyên trạng thái hoặc hiện loading xong tắt.
    } finally {
      isLoading.value = false;
    }
  }

  String get dateRangeText {
    final start = DateFormat('dd/MM/yyyy').format(startDate.value);
    final end = DateFormat('dd/MM/yyyy').format(endDate.value);
    return '$start - $end';
  }

  Future<void> pickCustomDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      updateDateRange(AnalyticsFilter.custom, customRange: picked);
    }
  }
}
