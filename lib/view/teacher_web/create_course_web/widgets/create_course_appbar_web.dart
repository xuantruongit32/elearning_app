import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCourseAppBarWeb extends StatelessWidget {
  final VoidCallback onSubmit;
  final Course? course;

  const CreateCourseAppBarWeb({super.key, required this.onSubmit, this.course});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return SliverAppBar(
      expandedHeight: isWeb ? 100 : 200, 
      collapsedHeight: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppColors.accent),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent, 
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onSubmit,
            icon: const Icon(Icons.save_outlined, size: 20),
            label: Text(
              course != null ? 'Cập nhật' : 'Hoàn tất',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: isWeb
            ? const EdgeInsets.only(left: 60, bottom: 16)
            : EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                bottom: 16,
              ),
        centerTitle: false,
        title: Text(
          course != null ? 'Chỉnh sửa khóa học' : 'Tạo khóa học mới',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            fontSize: isWeb ? 24 : null,
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
