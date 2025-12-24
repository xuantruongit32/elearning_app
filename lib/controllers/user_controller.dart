import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/respositories/user_repository.dart';
import 'package:elearning_app/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum UserSortOption { newest, oldest }

class UserController extends GetxController {
  final UserRepository _repo = UserRepository();
  final EmailService _emailService = EmailService();

  var allUsers = <UserModel>[].obs;
  var studentList = <UserModel>[].obs;
  var teacherList = <UserModel>[].obs;

  var searchQuery = ''.obs;
  var selectedSort = UserSortOption.newest.obs;
  var dateRange = Rx<DateTimeRange?>(null);

  // Biến quản lý trạng thái đang gửi của nút bấm
  var isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    everAll([
      allUsers,
      searchQuery,
      selectedSort,
      dateRange,
    ], (_) => applyFilters());
  }

  Future<void> fetchUsers() async {
    try {
      final users = await _repo.getUsers();
      allUsers.assignAll(users);
    } catch (e) {
      print(
        'Lỗi tải user: $e',
      ); // Chỉ in log, không hiện popup gây phiền lúc mới vào
    }
  }

  void applyFilters() {
    List<UserModel> temp = List.from(allUsers);

    if (dateRange.value != null) {
      DateTime start = dateRange.value!.start;
      DateTime end = dateRange.value!.end
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      temp = temp.where((u) {
        DateTime date = u.createdAt;
        return date.isAfter(start) && date.isBefore(end);
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      temp = temp.where((u) {
        return (u.fullName?.toLowerCase().contains(query) ?? false) ||
            u.email.toLowerCase().contains(query) ||
            u.uid.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedSort.value == UserSortOption.newest) {
      temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      temp.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    studentList.assignAll(
      temp.where((u) => u.role == UserRole.student).toList(),
    );
    teacherList.assignAll(
      temp.where((u) => u.role == UserRole.teacher).toList(),
    );
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await _sendDeleteNotification(user);
      await _repo.deleteUser(user.uid);
      allUsers.removeWhere((u) => u.uid == user.uid);

      // Thay Snackbar bằng Dialog báo thành công
      _showAlertDialog(
        'Thành công',
        'Đã xóa người dùng và gửi mail thông báo.',
      );
    } catch (e) {
      // Thay Snackbar bằng Dialog báo lỗi
      _showAlertDialog('Lỗi', 'Không thể xóa: $e');
    }
  }

  Future<void> _sendDeleteNotification(UserModel user) async {
    final name = user.fullName ?? 'Người dùng';
    final subject = 'Thông báo: Tài khoản của bạn đã bị xóa';
    final message =
        '''
      Chào $name,
      
      Tài khoản của bạn (Email: ${user.email}) tại hệ thống TT Elearning đã bị xóa bởi Quản trị viên.
      Lý do: Vi phạm chính sách hoặc theo yêu cầu quản lý hệ thống.
      
      Trân trọng,
      Đội ngũ Quản trị viên.
    ''';

    try {
      await _emailService.sendEmail(
        toName: name,
        toEmail: user.email,
        subject: subject,
        message: message,
      );
    } catch (e) {
      print('Lỗi gửi mail thông báo xóa: $e');
    }
  }

  void showEmailDialog(BuildContext context, UserModel user) {
    isSending.value = false; // Reset trạng thái

    final subjectController = TextEditingController(
      text: 'Thông báo từ TT Elearning',
    );
    final messageController = TextEditingController();
    final userName = user.fullName ?? 'Người dùng';

    Get.dialog(
      AlertDialog(
        title: Text('Gửi mail tới: $userName'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          // Nút Hủy
          Obx(
            () => TextButton(
              onPressed: isSending.value ? null : () => Get.back(),
              child: const Text('Hủy'),
            ),
          ),

          // Nút Gửi
          Obx(
            () => ElevatedButton(
              onPressed: isSending.value
                  ? null
                  : () async {
                      if (messageController.text.isEmpty) {
                        _showAlertDialog('Lỗi', 'Nội dung không được để trống');
                        return;
                      }

                      isSending.value = true; // Bắt đầu xoay

                      try {
                        await _emailService.sendEmail(
                          toName: userName,
                          toEmail: user.email,
                          subject: subjectController.text,
                          message: messageController.text,
                        );

                        Get.back(); // Đóng dialog nhập liệu trước

                        // Hiện thông báo thành công bằng Dialog
                        _showAlertDialog(
                          'Thành công',
                          'Đã gửi email tới ${user.email}',
                        );
                      } catch (e) {
                        isSending.value = false; // Tắt xoay để ấn lại

                        // Hiện thông báo lỗi bằng Dialog
                        _showAlertDialog('Lỗi', 'Đã có lỗi xảy ra: $e');
                      }
                    },
              child: isSending.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(' Gửi ngay '),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Hàm tiện ích để hiện Dialog thay cho Snackbar
  void _showAlertDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange.value,
    );
    if (picked != null) dateRange.value = picked;
  }

  void clearDateFilter() => dateRange.value = null;

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
}
