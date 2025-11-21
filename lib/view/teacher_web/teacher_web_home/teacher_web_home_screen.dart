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
        'route': AppRoutes.myCourses,
      },
      {
        'title': 'Tạo khóa học',
        'icon': Icons.add_circle,
        'route': AppRoutes.createCourse,
      },
      {
        'title': 'Phân tích',
        'icon': Icons.analytics,
        'route': AppRoutes.teacherAnalytics,
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
        'route': AppRoutes.teacherPayments,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 900;
          final double horizontalPadding = isDesktop ? 100.0 : 16.0;

          const double maxCardWidth = 300.0;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: isDesktop ? 150 : 200,
                pinned: true,
                backgroundColor: AppColors.primary,
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
                  if (isDesktop) const SizedBox(width: 24),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Bảng điều khiển cho Giảng viên',
                    style: TextStyle(color: AppColors.accent),
                  ),
                  centerTitle: isDesktop ? false : true,
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
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
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
                    maxCrossAxisExtent: maxCardWidth,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.3,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
