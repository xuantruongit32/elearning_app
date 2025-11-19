import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/withdrawal.dart';
import 'package:elearning_app/respositories/withdrawal_repository.dart';
import 'package:elearning_app/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum WithdrawalSortOption { newest, oldest, amountHigh, amountLow }

class WithdrawalController extends GetxController {
  final WithdrawalRepository _repo = WithdrawalRepository();
  final EmailService _emailService = EmailService();

  var allWithdrawals = <Withdrawal>[].obs;

  // Dữ liệu sau khi lọc
  var pendingList = <Withdrawal>[].obs;
  var historyList = <Withdrawal>[].obs;

  // filters
  var searchQuery = ''.obs;
  var selectedSort = WithdrawalSortOption.newest.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawals();
    everAll([allWithdrawals, searchQuery, selectedSort], (_) => applyFilters());
  }

  Future<void> fetchWithdrawals() async {
    try {
      final data = await _repo.getWithdrawals();
      allWithdrawals.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải yêu cầu rút tiền: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void applyFilters() {
    List<Withdrawal> temp = List.from(allWithdrawals);

    // search
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      temp = temp.where((item) {
        return item.teacherId.toLowerCase().contains(query) ||
            item.accountName.toLowerCase().contains(query) ||
            item.bankName.toLowerCase().contains(query) ||
            item.accountNumber.contains(query);
      }).toList();
    }

    // sort
    switch (selectedSort.value) {
      case WithdrawalSortOption.newest:
        temp.sort((a, b) => b.date.compareTo(a.date));
        break;
      case WithdrawalSortOption.oldest:
        temp.sort((a, b) => a.date.compareTo(b.date));
        break;
      case WithdrawalSortOption.amountHigh:
        temp.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case WithdrawalSortOption.amountLow:
        temp.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    pendingList.assignAll(temp.where((e) => e.status == 'pending').toList());
    historyList.assignAll(temp.where((e) => e.status != 'pending').toList());
  }

  Future<void> _sendEmailNotification({
    required String teacherId,
    required bool isApproved,
    required double amount,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .get();

      if (!userDoc.exists) return;

      final userData = userDoc.data();
      final email = userData?['email'];
      final fullName = userData?['fullName'] ?? 'Quý thầy/cô';

      if (email == null) return;

      String subject;
      String message;
      final amountStr = formatCurrency(amount);

      if (isApproved) {
        subject = 'Thông báo: Yêu cầu rút tiền ĐÃ ĐƯỢC DUYỆT';
        message =
            '''
          Chào $fullName,
          
          Yêu cầu rút số tiền $amountStr của bạn đã được Admin phê duyệt thành công.
          Tiền sẽ được chuyển vào tài khoản ngân hàng của bạn trong thời gian sớm nhất.
          
          Trân trọng,
          Đội ngũ Admin.
        ''';
      } else {
        subject = 'Thông báo: Yêu cầu rút tiền BỊ TỪ CHỐI';
        message =
            '''
          Chào $fullName,
          
          Yêu cầu rút số tiền $amountStr của bạn đã bị từ chối.
          Số tiền này đã được hoàn lại vào ví dư của bạn trên hệ thống.
          Vui lòng kiểm tra lại thông tin hoặc liên hệ hỗ trợ nếu có thắc mắc.
          
          Trân trọng,
          Đội ngũ Admin.
        ''';
      }

      await _emailService.sendEmail(
        toName: fullName,
        toEmail: email,
        message: message,
        subject: subject,
      );

      print('Đã gửi email thông báo đến $email');
    } catch (e) {
      print('Lỗi khi gửi email: $e');
    }
  }

  Future<void> approve(Withdrawal item) async {
    try {
      await _repo.approveWithdrawal(item.id);

      _sendEmailNotification(
        teacherId: item.teacherId,
        isApproved: true,
        amount: item.amount,
      );

      await fetchWithdrawals();
      Get.snackbar(
        'Thành công',
        'Đã duyệt yêu cầu và gửi mail thông báo',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể duyệt: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> reject(Withdrawal item) async {
    try {
      await _repo.rejectWithdrawal(item.id, item.teacherId, item.amount);

      _sendEmailNotification(
        teacherId: item.teacherId,
        isApproved: false,
        amount: item.amount,
      );

      await fetchWithdrawals();
      Get.snackbar(
        'Đã từ chối',
        'Đã hoàn tiền và gửi mail thông báo',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể từ chối: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  String formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }
}
