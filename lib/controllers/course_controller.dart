import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/category_firestore.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/respositories/category_respository.dart';
import 'package:elearning_app/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum CourseSortOption { newest, oldest, rating, revenue }

class CourseController extends GetxController {
  final CourseRepository _courseRepository = CourseRepository();
  final CategoryRepository _categoryRepository = Get.put(CategoryRepository());
  final EmailService _emailService = EmailService();

  var allCourses = <Course>[].obs;
  var filteredCourses = <Course>[].obs;

  var categories = <CategoryFirestoreModel>[].obs;
  var categoryMap = <String, String>{}.obs;
  var selectedCategory = 'all'.obs;

  var searchQuery = ''.obs;
  var selectedSort = CourseSortOption.newest.obs;

  // Biến trạng thái loading cho hành động xóa
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();

    everAll([
      allCourses,
      searchQuery,
      selectedSort,
      selectedCategory,
    ], (_) => applyFilters());
  }

  void fetchInitialData() {
    categories.bindStream(_categoryRepository.getCategoriesforWeb());

    ever(categories, (List<CategoryFirestoreModel> cats) {
      final map = <String, String>{};
      for (var cat in cats) {
        map[cat.id] = cat.name;
      }
      categoryMap.value = map;
    });

    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await _courseRepository.getCourses();
      allCourses.assignAll(courses);
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  void applyFilters() {
    List<Course> result = List.from(allCourses);

    if (selectedCategory.value != 'all') {
      result = result
          .where((course) => course.categoryId == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();
      result = result.where((course) {
        bool matchTitle = course.title.toLowerCase().contains(query);
        bool matchId = course.id.toLowerCase().contains(query);
        bool matchInstructor = course.instructorId.toLowerCase().contains(
          query,
        );
        return matchTitle || matchId || matchInstructor;
      }).toList();
    }

    switch (selectedSort.value) {
      case CourseSortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CourseSortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case CourseSortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case CourseSortOption.revenue:
        result.sort((a, b) {
          double revenueA = a.price * a.enrollmentCount;
          double revenueB = b.price * b.enrollmentCount;
          return revenueB.compareTo(revenueA);
        });
        break;
    }

    filteredCourses.assignAll(result);
  }

  void deleteCourse(String courseId) {
    // Reset trạng thái loading trước khi mở dialog
    isDeleting.value = false;
    final courseToDelete = allCourses.firstWhereOrNull((c) => c.id == courseId);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const Text('Cảnh báo xóa'),
        content: const Text(
          'Hành động này sẽ xóa vĩnh viễn khóa học và dữ liệu liên quan.\nBạn có chắc chắn không?',
        ),
        actions: [
          Obx(
            () => TextButton(
              child: Text('Hủy', style: TextStyle(color: AppColors.secondary)),
              onPressed: isDeleting.value ? null : () => Get.back(),
            ),
          ),

          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: isDeleting.value
                  ? null // Disable khi đang chạy
                  : () async {
                      isDeleting.value = true;

                      try {
                        if (courseToDelete != null) {
                          await _sendDeletionNotification(courseToDelete);
                        }

                        await _courseRepository.deleteCourse(courseId);
                        allCourses.removeWhere((c) => c.id == courseId);

                        Get.back(); // Đóng dialog xác nhận xóa trước

                        // Hiện thông báo thành công bằng Dialog
                        _showAlertDialog(
                          'Thành công',
                          'Đã xóa khóa học và gửi mail thông báo cho giảng viên',
                        );
                      } catch (e) {
                        isDeleting.value = false; // Tắt xoay để ấn lại

                        // Hiện thông báo lỗi bằng Dialog
                        _showAlertDialog('Lỗi', 'Không thể xóa: $e');
                      }
                    },
              child: isDeleting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(' Xóa vĩnh viễn '),
            ),
          ),
        ],
      ),
      barrierDismissible: false, // Không cho bấm ra ngoài tắt
    );
  }

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

  Future<void> _sendDeletionNotification(Course course) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(course.instructorId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        final teacherEmail = userData?['email'];
        final teacherName = userData?['fullName'] ?? 'Giảng viên';

        if (teacherEmail != null) {
          final message =
              '''
            Chào $teacherName,
            
            Khóa học của bạn mang tên "${course.title}" (ID: ${course.id}) đã bị xóa khỏi hệ thống bởi Quản trị viên.
            Lý do: Vi phạm chính sách nội dung hoặc theo yêu cầu quản lý.
            
            Nếu bạn có thắc mắc, vui lòng liên hệ với bộ phận hỗ trợ của chúng tôi.
            
            Trân trọng,
            Đội ngũ TT Elearning.
          ''';

          await _emailService.sendEmail(
            toName: teacherName,
            toEmail: teacherEmail,
            message: message,
            subject: 'Thông báo: Khóa học đã bị xóa',
          );
        }
      }
    } catch (e) {
      print('Lỗi khi gửi mail thông báo xóa khóa học: $e');
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }
}
