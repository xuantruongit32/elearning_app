import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentProgressAppBar extends StatelessWidget {
  const StudentProgressAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: kToolbarHeight + 48,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: AppColors.accent),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          bottom: 64,
        ),
        title: Text(
          "Tiến độ học tập",
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.accent.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'Tiến độ'),
            Tab(text: 'Hiệu suất'),
          ],
        ),
      ),
    );
  }
}
