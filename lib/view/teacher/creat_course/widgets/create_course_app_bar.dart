import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCourseAppBar extends StatelessWidget {
  final VoidCallback onSubmit;

  const CreateCourseAppBar({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppColors.accent),
      ),
      actions: [
        TextButton(
          onPressed: onSubmit,
          child: const Text(
            'Create',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          bottom: 16,
        ),
        title: Text(
          'Create New Course',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
