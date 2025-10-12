import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/course/course_detail/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsSection extends StatelessWidget {
  final String courseId;
  const ReviewsSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final result = await Get.dialog<Map<String, dynamic>>(
                  ReviewDialog(courseId: courseId),
                );
                if (result != null) {
                  Get.snackbar(
                    'Success',
                    'Thank you for your review!',
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                  );
                }
              },
              label: const Text('Write a review'),
              icon: const Icon(Icons.rate_review),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildReviewTile(
              context,
              name: 'User ${index + 1}',
              rating: 4.5,
              comment: 'Great course! Very informative and well-structured.',
              date: '2 days ago',
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewTile(
    BuildContext context, {
    required String name,
    required double rating,
    required String comment,
    required String date,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  name[0],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 16,
                            color: AppColors.primary,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
