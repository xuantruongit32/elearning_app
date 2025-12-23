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

  // Dữ liệu gốc
  var allUsers = <UserModel>[].obs;

  // Dữ liệu hiển thị cho 2 tabs
  var studentList = <UserModel>[].obs;
  var teacherList = <UserModel>[].obs;

  // Filters
  var searchQuery = ''.obs;
  var selectedSort = UserSortOption.newest.obs;
  var dateRange = Rx<DateTimeRange?>(null);

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
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách người dùng: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void applyFilters() {
    List<UserModel> temp = List.from(allUsers);

    // lọc theo ngày
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

    // tìm kiếm
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      temp = temp.where((u) {
        return (u.fullName?.toLowerCase().contains(query) ?? false) ||
            u.email.toLowerCase().contains(query) ||
            u.uid.toLowerCase().contains(query);
      }).toList();
    }

    // sort
    if (selectedSort.value == UserSortOption.newest) {
      temp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      temp.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    // chia tab
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

      Get.snackbar(
        'Thành công',
        'Đã xóa người dùng và gửi mail thông báo',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      
      Nếu bạn cho rằng đây là sự nhầm lẫn, vui lòng liên hệ lại với bộ phận hỗ trợ.
      
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
      print('Đã gửi mail xóa user tới: ${user.email}');
    } catch (e) {
      print('Lỗi gửi mail thông báo xóa: $e');
    }
  }

  void showEmailDialog(BuildContext context, UserModel user) {
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
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              if (messageController.text.isEmpty) {
                Get.snackbar(
                  'Lỗi',
                  'Nội dung không được để trống',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              Get.snackbar(
                'Đang gửi...',
                'Vui lòng chờ',
                showProgressIndicator: true,
              );

              await _emailService.sendEmail(
                toName: userName,
                toEmail: user.email,
                subject: subjectController.text,
                message: messageController.text,
              );

              Get.closeCurrentSnackbar();
              Get.snackbar(
                'Thành công',
                'Đã gửi email tới ${user.email}',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(' Gửi ngay '),
          ),
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
