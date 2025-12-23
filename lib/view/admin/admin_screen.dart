import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/controllers/admin_controller.dart'; // Đảm bảo đường dẫn đúng
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/admin/widgets/admin_payment_screen.dart';
import 'package:elearning_app/view/admin/widgets/admin_user_screen.dart';
import 'package:elearning_app/view/admin/widgets/category_screen.dart';
import 'package:elearning_app/view/admin/widgets/course_screen.dart';
import 'package:elearning_app/view/admin/widgets/dashboard_screen.dart';
import 'package:elearning_app/view/admin/widgets/review_screen.dart';
import 'package:elearning_app/view/admin/widgets/withdrawal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({super.key});

  static const List<Widget> _adminPages = <Widget>[
    DashboardScreen(),
    CategoryScreen(),
    CourseScreen(),
    AdminUserScreen(),
    AdminPaymentScreen(),
    AdminWithdrawalScreen(),
    ReviewScreen(),
  ];

  static const List<String> _adminPageTitles = <String>[
    'Admin: Tổng quan',
    'Admin: Quản lí Danh mục',
    'Admin: Quản lí Khóa học',
    'Admin: Quản lí Người dùng',
    'Admin: Quản lí Thanh toán',
    'Admin: Quản lí Rút tiền',
    'Admin: Quản lí Đánh giá',
  ];

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(AdminController());

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Obx(
          () => Text(
            _adminPageTitles[controller.selectedIndex.value],
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 256,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => NavigationRail(
                      backgroundColor: Colors.transparent,
                      selectedIndex: controller.selectedIndex.value,
                      onDestinationSelected: (index) =>
                          controller.changeTab(index),
                      labelType: NavigationRailLabelType.none,
                      extended: true,
                      indicatorColor: AppColors.primary.withOpacity(0.1),
                      selectedIconTheme: const IconThemeData(
                        color: AppColors.primary,
                      ),
                      unselectedIconTheme: IconThemeData(
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                      selectedLabelTextStyle: theme.textTheme.bodyMedium
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      unselectedLabelTextStyle: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.secondary),
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard_outlined),
                          selectedIcon: Icon(Icons.dashboard),
                          label: Text('Tổng quan'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.category_outlined),
                          selectedIcon: Icon(Icons.category),
                          label: Text('Danh mục'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.book_outlined),
                          selectedIcon: Icon(Icons.book),
                          label: Text('Khóa học'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.people_alt_outlined),
                          selectedIcon: Icon(Icons.people_alt),
                          label: Text('Người dùng'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.payment_outlined),
                          selectedIcon: Icon(Icons.payment),
                          label: Text('Thanh toán'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.paypal),
                          selectedIcon: Icon(Icons.paypal_outlined),
                          label: Text('Rút tiền'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.reviews_outlined),
                          selectedIcon: Icon(Icons.reviews),
                          label: Text('Đánh giá'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1, height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.secondary),
                  title: Text(
                    'Đăng xuất',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  onTap: () => _handleLogout(context),
                  hoverColor: AppColors.primary.withOpacity(0.05),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(() => _adminPages[controller.selectedIndex.value]),
            ),
          ),
        ],
      ),
    );
  }
}
