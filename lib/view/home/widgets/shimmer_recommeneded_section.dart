import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/home/widgets/shimmer_recommended_course_card.dart';
import 'package:flutter/material.dart';

class ShimmerRecommenededSection extends StatelessWidget {
  const ShimmerRecommenededSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gợi ý cho bạn',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextButton(onPressed: null, child: Text('Xem tất cả')),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(right: 16),
              child: ShimmerRecommendedCourseCard(),
            ),
          ),
        ),
      ],
    );
  }
}
