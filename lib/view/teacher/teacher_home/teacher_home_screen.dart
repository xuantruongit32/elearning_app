import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/core/utils/app_dialogs.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/teacher/teacher_home/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    context.read<AuthBloc>().add(LogoutRequested());
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.accent),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Bảng điều khiển',
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
                  title: 'Khóa học của tôi',
                  icon: Icons.book,
                  onTap: () => Get.toNamed(AppRoutes.myCourses),
                ),
                DashboardCard(
                  title: 'Tạo khóa học',
                  icon: Icons.add_circle,
                  onTap: () => Get.toNamed(AppRoutes.createCourse),
                ),
                DashboardCard(
                  title: 'Phân tích',
                  icon: Icons.analytics,
                  onTap: () => Get.toNamed(AppRoutes.teacherAnalytics),
                ),
                DashboardCard(
                  title: 'Tiến độ học viên',
                  icon: Icons.people,
                  onTap: () => Get.toNamed(AppRoutes.studentProgress),
                ),
                DashboardCard(
                  title: 'Tin nhắn',
                  icon: Icons.chat,
                  onTap: () => Get.toNamed(AppRoutes.teacherChats),
                ),
                DashboardCard(
                  title: 'Thanh toán',
                  icon: Icons.payment,
                  onTap: () => Get.toNamed(AppRoutes.teacherPayments),
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
