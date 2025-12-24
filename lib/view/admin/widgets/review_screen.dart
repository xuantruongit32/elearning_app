import 'package:elearning_app/controllers/review_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewController controller = Get.put(ReviewController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) =>
                          controller.searchQuery.value = value,
                      decoration: InputDecoration(
                        hintText: 'Tìm theo ID...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.accent.withOpacity(0.3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<bool>(
                          value: controller.isNewestFirst.value,
                          items: const [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Mới nhất'),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('Cũ nhất'),
                            ),
                          ],
                          onChanged: (val) =>
                              controller.isNewestFirst.value = val!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Bộ lọc Sao
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => Row(
                          children: [
                            const Text(
                              'Sao:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(controller, 0, 'Tất cả'),
                            _buildFilterChip(controller, 5, '5'),
                            _buildFilterChip(controller, 4, '4'),
                            _buildFilterChip(controller, 3, '3'),
                            _buildFilterChip(controller, 2, '2'),
                            _buildFilterChip(controller, 1, '1'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  Obx(() {
                    final hasDate = controller.startDate.value != null;
                    return InkWell(
                      onTap: () => controller.pickDateRange(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: hasDate
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: hasDate
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: hasDate ? AppColors.primary : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hasDate
                                  ? '${DateFormat('dd/MM').format(controller.startDate.value!)} - ${DateFormat('dd/MM').format(controller.endDate.value!)}'
                                  : 'Chọn ngày',
                              style: TextStyle(
                                color: hasDate
                                    ? AppColors.primary
                                    : Colors.black,
                                fontWeight: hasDate
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (hasDate) ...[
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => controller.clearDateFilter(),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: Obx(() {
            if (controller.filteredReviews.isEmpty) {
              return const Center(child: Text('Không tìm thấy đánh giá nào.'));
            }

            return ListView.separated(
              itemCount: controller.filteredReviews.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = controller.filteredReviews[index];
                return _buildReviewCard(review, controller);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    ReviewController controller,
    int value,
    String label,
  ) {
    final isSelected = controller.selectedStarFilter.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        visualDensity: VisualDensity.compact,
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (selected) {
          if (selected) controller.selectedStarFilter.value = value;
        },
      ),
    );
  }

  Widget _buildInfoRowWithCopy(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
           
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.copy, size: 14, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Review review, ReviewController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.accent,
                    radius: 16,
                    child: Text(
                      review.userName.isNotEmpty
                          ? review.userName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(review.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => controller.deleteReview(review.id),
              ),
            ],
          ),
          const Divider(),

          _buildInfoRowWithCopy(Icons.book, 'Course ID', review.courseId),
          _buildInfoRowWithCopy(Icons.person, 'User ID', review.userId),
          const SizedBox(height: 8),
          _buildInfoRowWithCopy(Icons.tag, 'Review ID', review.id),

          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
