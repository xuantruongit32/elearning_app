import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/admin/widgets/category_screen.dart';
import 'package:elearning_app/view/admin/widgets/course_screen.dart';
import 'package:elearning_app/view/admin/widgets/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Admin: Tổng quan', style: TextStyle(fontSize: 24)),
    );
  }
}


class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Admin: Quản lí Người dùng', style: TextStyle(fontSize: 24)),
    );
  }
}

class AdminPaymentScreen extends StatelessWidget {
  const AdminPaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Admin: Quản lí Thanh toán', style: TextStyle(fontSize: 24)),
    );
  }
}

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _adminPages = <Widget>[
    DashboardScreen(),
    CategoryScreen(),
    CourseScreen(),
    UserScreen(),
    AdminPaymentScreen(),
    ReviewScreen(),
  ];

  static const List<String> _adminPageTitles = <String>[
    'Admin: Tổng quan',
    'Admin: Quản lí Danh mục',
    'Admin: Quản lí Khóa học',
    'Admin: Quản lí Người dùng',
    'Admin: Quản lí Thanh toán',
    'Admin: Quản lí Đánh giá',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutRequested());
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Text(
          _adminPageTitles[_selectedIndex],
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
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
                  child: NavigationRail(
                    backgroundColor: Colors.transparent,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _onItemTapped,
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
                    // ---
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
                        icon: Icon(Icons.reviews_outlined),
                        selectedIcon: Icon(Icons.reviews),
                        label: Text('Đánh giá'),
                      ),
                    ],
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
                  onTap: _handleLogout,
                  hoverColor: AppColors.primary.withOpacity(0.05),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _adminPages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
