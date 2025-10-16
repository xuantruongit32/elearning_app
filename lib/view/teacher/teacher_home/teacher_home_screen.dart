import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/core/utils/app_dialogs.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/teacher/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: () async {
                  final confirm = await AppDialogs.showLogoutDialog();
                  if (confirm == true) {
                    Get.offAllNamed(AppRoutes.login);
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.accent),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Teacher Dashboard',
                style: TextStyle(color: AppColors.accent),
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
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                DashboardCard(
                  title: 'My Course',
                  icon: Icons.book,
                  onTap: () => Get.toNamed(AppRoutes.myCourses),
                ),
                DashboardCard(
                  title: 'Create Course',
                  icon: Icons.add_circle,
                  onTap: () => Get.toNamed(AppRoutes.createCourse),
                ),
                DashboardCard(
                  title: 'Analytics',
                  icon: Icons.analytics,
                  onTap: () {},
                ),
                DashboardCard(
                  title: 'Student Progress',
                  icon: Icons.people,
                  onTap: () {},
                ),
                DashboardCard(
                  title: 'Messages',
                  icon: Icons.chat,
                  onTap: () => Get.toNamed(AppRoutes.teacherChats),
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
