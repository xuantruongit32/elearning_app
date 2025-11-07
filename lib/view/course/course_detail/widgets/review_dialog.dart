import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/review.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewDialog extends StatefulWidget {
  final String courseId;
  final Review? existingReview;
  const ReviewDialog({super.key, required this.courseId, this.existingReview});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double _rating = 0;
  late final TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 0;
    _reviewController = TextEditingController(
      text: widget.existingReview?.comment ?? "",
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _rating = 0;
      _reviewController.clear();
    });
  }

  void _handleSubmit() {
    if (_rating > 0) {
      final result = {
        'action': widget.existingReview != null ? 'update' : 'add',
        'rating': _rating,
        'review': _reviewController.text,
      };
      _resetForm();
      Get.back(result: result);
    }
  }

  void _handleDelete() {
    final result = {'action': 'delete'};
    _resetForm();
    Get.back(result: result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existingReview != null
                  ? 'Chỉnh sửa đánh giá'
                  : 'Đánh giá & Nhận xét',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.primary,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Viết nhận xét của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (widget.existingReview != null)
                  Expanded(
                    child: TextButton(
                      onPressed: _handleDelete,
                      child: Text(
                        'Xóa',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _resetForm();
                      Get.back();
                    },
                    child: Text(
                      'Hủy',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _rating > 0 ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.existingReview != null ? 'Cập nhật' : 'Gửi',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
