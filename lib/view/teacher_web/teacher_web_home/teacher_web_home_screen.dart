import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/core/utils/app_dialogs.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/teacher/teacher_home/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TeacherWebHomeScreen extends StatelessWidget {
  const TeacherWebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Khóa học của tôi',
        'icon': Icons.book,
        'route': AppRoutes.myCoursesWeb,
      },
      {
        'title': 'Tạo khóa học',
        'icon': Icons.add_circle,
        'route': AppRoutes.createCourseWeb,
      },
      {
        'title': 'Phân tích',
        'icon': Icons.analytics,
        'route': AppRoutes.teacherAnalyticsWeb,
      },
      {
        'title': 'Tiến độ học viên',
        'icon': Icons.people,
        'route': AppRoutes.studentProgress,
      },
      {
        'title': 'Tin nhắn',
        'icon': Icons.chat,
        'route': AppRoutes.teacherChats,
      },
      {
        'title': 'Thanh toán',
        'icon': Icons.payment,
        'route': AppRoutes.teacherPaymentsWeb,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            toolbarHeight: kToolbarHeight,
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight,
            backgroundColor: AppColors.primary,
            title: const Text(
              'Bảng điều khiển cho Giảng viên',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: [
              Tooltip(
                message: 'Đăng xuất',
                child: IconButton(
                  onPressed: () async {
                    final confirm = await AppDialogs.showLogoutDialog();
                    if (confirm == true) {
                      context.read<AuthBloc>().add(LogoutRequested());
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.accent),
                ),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 100.0,
              vertical: 32,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = menuItems[index];
                return DashboardCard(
                  title: item['title'],
                  icon: item['icon'],
                  onTap: () => Get.toNamed(item['route']),
                );
              }, childCount: menuItems.length),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300.0,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
