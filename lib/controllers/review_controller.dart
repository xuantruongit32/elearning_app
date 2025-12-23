import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/review.dart';
import 'package:elearning_app/respositories/review_respository.dart';
import 'package:elearning_app/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final ReviewRepository _repository = Get.put(ReviewRepository());
  final EmailService _emailService = EmailService();

  var allReviews = <Review>[].obs;
  var filteredReviews = <Review>[].obs;

  var searchQuery = ''.obs;
  var selectedStarFilter = 0.obs;
  var isNewestFirst = true.obs;

  var startDate = Rxn<DateTime>(); // Rxn cho phép giá trị null
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchReviews();

    everAll([
      allReviews,
      searchQuery,
      selectedStarFilter,
      isNewestFirst,
      startDate,
      endDate,
    ], (_) => applyFilters());
  }

  Future<void> fetchReviews() async {
    final reviews = await _repository.getAllReviews();
    allReviews.assignAll(reviews);
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      locale: const Locale("vi", "VN"),
      fieldStartHintText: 'dd/mm/yyyy',
      fieldEndHintText: 'dd/mm/yyyy',
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
    }
  }

  void clearDateFilter() {
    startDate.value = null;
    endDate.value = null;
  }

  void applyFilters() {
    List<Review> result = List.from(allReviews);

    // 1. Search
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase().trim();

      result = result.where((review) {
        bool matchCourse = review.courseId.toLowerCase().contains(query);
        bool matchUser = review.userId.toLowerCase().contains(query);
        bool matchReview = review.id.toLowerCase().contains(query);
        bool matchName = review.userName.toLowerCase().contains(query);

        return matchCourse || matchUser || matchReview || matchName;
      }).toList();
    }

    if (selectedStarFilter.value != 0) {
      result = result
          .where((review) => review.rating.round() == selectedStarFilter.value)
          .toList();
    }

    if (startDate.value != null && endDate.value != null) {
      final start = DateTime(
        startDate.value!.year,
        startDate.value!.month,
        startDate.value!.day,
      );
      final end = DateTime(
        endDate.value!.year,
        endDate.value!.month,
        endDate.value!.day,
        23,
        59,
        59,
      );

      result = result.where((review) {
        return review.createdAt.isAfter(start) &&
            review.createdAt.isBefore(end);
      }).toList();
    }

    result.sort((a, b) {
      if (isNewestFirst.value) {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });
    filteredReviews.assignAll(result);
  }

  void deleteReview(String reviewId) {
    final reviewToDelete = allReviews.firstWhereOrNull((r) => r.id == reviewId);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa đánh giá này không?'),
        actions: [
          TextButton(
            child: Text('Hủy', style: TextStyle(color: AppColors.secondary)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
            onPressed: () async {
              Get.back(); // Đóng dialog

              // Xóa review
              await _repository.deleteReview(reviewId);

              // === GỬI EMAIL THÔNG BÁO ===
              if (reviewToDelete != null) {
                _sendDeletionNotification(reviewToDelete);
              }

              fetchReviews(); // Tải lại danh sách

              Get.snackbar(
                'Thành công',
                'Đã xóa đánh giá và gửi mail thông báo',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendDeletionNotification(Review review) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(review.userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        final userEmail = userData?['email'];
        final userName = userData?['fullName'] ?? 'Người dùng';

        if (userEmail != null) {
          final message =
              '''
            Chào $userName,
            
            Bài đánh giá của bạn cho khóa học (ID: ${review.courseId}) đã bị xóa bởi Quản trị viên.
            
            Nội dung bài đánh giá: "${review.comment}"
            
            Lý do: Vi phạm tiêu chuẩn cộng đồng.
            
            Nếu bạn có thắc mắc, vui lòng liên hệ bộ phận hỗ trợ.
            
            Trân trọng,
            Đội ngũ TT Elearning.
          ''';

          await _emailService.sendEmail(
            toName: userName,
            toEmail: userEmail,
            message: message,
            subject: 'Thông báo: Bài đánh giá của bạn đã bị xóa',
          );
        }
      }
    } catch (e) {
      print('Lỗi khi gửi mail thông báo: $e');
    }
  }
}
