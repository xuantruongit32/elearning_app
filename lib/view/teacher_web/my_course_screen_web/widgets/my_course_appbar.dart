import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCoursesAppBarWeb extends StatelessWidget {
  const MyCoursesAppBarWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return SliverAppBar(
      expandedHeight: isWeb ? 120 : 200,
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppColors.accent),
      ),
      actions: [
        if (isWeb)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Tạo khóa học"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
            ),
          )
        else
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.accent),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: isWeb,
        titlePadding: isWeb
            ? const EdgeInsets.only(bottom: 16)
            : EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                bottom: 16,
              ),
        title: Text(
          'Khóa học của tôi',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            fontSize: isWeb ? 24 : null,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
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
