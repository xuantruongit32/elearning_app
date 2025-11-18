import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/review.dart';
import 'package:elearning_app/respositories/review_respository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final ReviewRepository _repository = Get.put(ReviewRepository());

  var allReviews = <Review>[].obs;
  var filteredReviews = <Review>[].obs;

  var searchQuery = ''.obs;
  var selectedStarFilter = 0.obs;
  var isNewestFirst = true.obs;

  // === MỚI: Biến lưu khoảng ngày ===
  var startDate = Rxn<DateTime>(); // Rxn cho phép giá trị null
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchReviews();

    // Thêm startDate và endDate vào danh sách lắng nghe
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

  // === MỚI: Hàm chọn khoảng ngày ===
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
              primary: AppColors.primary, // Màu chủ đạo của App
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

  // === MỚI: Hàm xóa lọc ngày ===
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
        // Kiểm tra trùng khớp ID khóa học
        bool matchCourse = review.courseId.toLowerCase().contains(query);
        // Kiểm tra trùng khớp ID người dùng
        bool matchUser = review.userId.toLowerCase().contains(query);
        // Kiểm tra trùng khớp ID bài review
        bool matchReview = review.id.toLowerCase().contains(query);
        // (Khuyến nghị thêm) Kiểm tra trùng khớp Tên người dùng
        bool matchName = review.userName.toLowerCase().contains(query);

        // Trả về true nếu khớp bất kỳ điều kiện nào
        return matchCourse || matchUser || matchReview || matchName;
      }).toList();
    }

    // 2. Filter Star
    if (selectedStarFilter.value != 0) {
      result = result
          .where((review) => review.rating.round() == selectedStarFilter.value)
          .toList();
    }

    // 3. === MỚI: Filter Date ===
    if (startDate.value != null && endDate.value != null) {
      // Lấy đầu ngày của startDate (00:00:00)
      final start = DateTime(
        startDate.value!.year,
        startDate.value!.month,
        startDate.value!.day,
      );
      // Lấy cuối ngày của endDate (23:59:59)
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

    // 4. Sort
    result.sort((a, b) {
      if (isNewestFirst.value) {
        return b.createdAt.compareTo(a.createdAt);
      } else {
        return a.createdAt.compareTo(b.createdAt);
      }
    });
    filteredReviews.assignAll(result);
  }

  // Hàm xóa review
  void deleteReview(String reviewId) {
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
              Get.back();
              await _repository.deleteReview(reviewId);
              fetchReviews();
              Get.snackbar(
                'Thành công',
                'Đã xóa đánh giá và cập nhật điểm khóa học',
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
}
