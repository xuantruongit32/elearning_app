import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/respositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum PaymentSortOption { newest, oldest, amountHigh, amountLow }

class PaymentController extends GetxController {
  final PaymentRepository _paymentRepository = PaymentRepository();

  var allPayments = <SimplePayment>[].obs;
  var filteredPayments = <SimplePayment>[].obs;

  var searchQuery = ''.obs;
  var selectedSort = PaymentSortOption.newest.obs;
  var dateRange = Rx<DateTimeRange?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPayments();

    everAll([
      allPayments,
      searchQuery,
      selectedSort,
      dateRange,
    ], (_) => applyFilters());
  }

  Future<void> fetchPayments() async {
    try {
      final payments = await _paymentRepository.getPayments();
      allPayments.assignAll(payments);
    } catch (e) {
      print("Error fetching payments: $e");
      // Đã bỏ Snackbar để tránh lỗi crash trên Web
    }
  }

  void pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange.value,
      helpText: 'Chọn khoảng thời gian',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      saveText: 'Xong',
    );
    if (picked != null) {
      dateRange.value = picked;
    }
  }

  void clearDateFilter() {
    dateRange.value = null;
  }

  void applyFilters() {
    List<SimplePayment> result = List.from(allPayments);

    if (dateRange.value != null) {
      DateTime start = dateRange.value!.start;
      DateTime end = dateRange.value!.end
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      result = result.where((p) {
        DateTime date = p.date.toDate();
        return date.isAfter(start) && date.isBefore(end);
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      result = result.where((p) {
        return p.id.toLowerCase().contains(query) ||
            p.teacherId.toLowerCase().contains(query) ||
            p.studentId.toLowerCase().contains(query) ||
            p.courseId.toLowerCase().contains(query);
      }).toList();
    }

    switch (selectedSort.value) {
      case PaymentSortOption.newest:
        result.sort((a, b) => b.date.compareTo(a.date));
        break;
      case PaymentSortOption.oldest:
        result.sort((a, b) => a.date.compareTo(b.date));
        break;
      case PaymentSortOption.amountHigh:
        result.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case PaymentSortOption.amountLow:
        result.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    filteredPayments.assignAll(result);
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  double get totalRevenue =>
      filteredPayments.fold(0, (sum, item) => sum + item.amount);
}
