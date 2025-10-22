import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/review.dart';
import 'package:elearning_app/respositories/review_respository.dart';
import 'package:elearning_app/view/course/course_detail/widgets/review_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ReviewsSection extends StatefulWidget {
  final String courseId;
  const ReviewsSection({super.key, required this.courseId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final ReviewRepository _reviewRepository = ReviewRepository();
  List<Review> _reviews = [];
  bool _isLoading = true;
  final _auth = FirebaseAuth.instance;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reviews = await _reviewRepository.getCourseReviews(widget.courseId);

      if (!mounted) return;

      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load reviews';
        _isLoading = false;
      });
    }
  }

  Future<void> _showReviewDialog([Review? existingReview]) async {
    final result = await Get.dialog<Map<String, dynamic>>(
      ReviewDialog(
        courseId: widget.courseId,
        key: UniqueKey(), // force new instance
        existingReview: existingReview,
      ),
      barrierDismissible: false, // prevent closing by tapping outside
    );

    if (result != null) {
      await _handleReviewAction(result);
    }
  }

  Future<void> _handleReviewAction(Map<String, dynamic> result) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'Please sign in to review',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final action = result['action'] as String;

      // check if user has already reviewed
      final existingReview = _reviews.firstWhereOrNull(
        (review) => review.userId == currentUser.uid,
      );

      switch (action) {
        case 'add':
          if (existingReview != null) {
            Get.snackbar(
              'Error',
              'You have already reviewed this course',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            setState(() => _isLoading = false);
            return;
          }
          final rating = (result['rating'] as num).toDouble();
          final comment = result['review'] as String;
          final newReview = Review(
            id: '',
            courseId: widget.courseId,
            userId: currentUser.uid,
            userName: currentUser.displayName ?? 'Anonymous',
            rating: rating,
            comment: comment,
            createdAt: DateTime.now(),
          );
          await _reviewRepository.addReview(newReview);
          break;

        case 'update':
          if (existingReview != null) {
            final rating = (result['rating'] as num).toDouble();
            final comment = result['review'] as String;
            final updatedReview = Review(
              id: existingReview.id,
              courseId: widget.courseId,
              userId: currentUser.uid,
              userName: currentUser.displayName ?? 'Anonymous',
              rating: rating,
              comment: comment,
              createdAt: DateTime.now(),
            );
            await _reviewRepository.updateReview(updatedReview);
          }
          break;

        case 'delete':
          if (existingReview != null) {
            await _reviewRepository.deleteReview(existingReview.id);
          }
          break;
      }
      await _loadReviews();

      // refresh course details to update rating and review count
      context.read<CourseBloc>().add(RefreshCourseDetail(widget.courseId));

      Get.snackbar(
        'Success',
        _getSuccessMessage(action),
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to ${result['action']} review',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _getSuccessMessage(String action) {
    switch (action) {
      case 'add':
        return 'Thank you for your review';
      case 'update':
        return 'Your review has been updated!';
      case 'delete':
        return 'Your review has been deleted';
      default:
        return 'Action completed successfully!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _auth.currentUser;

    final userReview = currentUser != null
        ? _reviews.firstWhereOrNull(
            (review) => review.userId == currentUser.uid,
          )
        : null;

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
              onPressed: _isLoading
                  ? null
                  : () => _showReviewDialog(userReview),
              label: Text(
                userReview != null ? 'Edit Review' : 'Write a Review',
              ),
              icon: const Icon(Icons.rate_review),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(_error!, style: theme.textTheme.bodyLarge),
                TextButton(onPressed: _loadReviews, child: const Text('Retry')),
              ],
            ),
          )
        else if (_reviews.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  size: 48,
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No reviews yet',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be first to review this course',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _buildReviewTile(
                context,
                review: review,
                isCurrentUserReview: currentUser?.uid == review.userId,
              );
            },
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final differece = now.difference(date);

    if (differece.inDays == 0) {
      if (differece.inHours == 0) {
        return '${differece.inMinutes} minutes ago';
      }
      return '${differece.inHours} hours ago';
    } else if (differece.inDays < 7) {
      return '${differece.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildReviewTile(
    BuildContext context, {
    required Review review,
    required bool isCurrentUserReview,
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
                  review.userName[0],
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
                      review.userName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: AppColors.primary,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCurrentUserReview)
                IconButton(
                  onPressed: () => _showReviewDialog,
                  icon: const Icon(Icons.more_vert),
                ),
            ],
          ),
          Text(review.comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
