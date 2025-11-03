import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/core/utils/app_dialogs.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/profile/widgets/profile_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileOptionCard(
          title: 'Chỉnh sửa hồ sơ',
          subtitle: 'Cập nhật thông tin cá nhân của bạn',
          icon: Icons.edit_outlined,
          onTap: () => Get.toNamed(AppRoutes.editProfile),
        ),
        ProfileOptionCard(
          title: 'Thông báo',
          subtitle: 'Quản lý cài đặt thông báo của bạn',
          icon: Icons.notifications_outlined,
          onTap: () => Get.toNamed(AppRoutes.notifications),
        ),
        ProfileOptionCard(
          title: 'Cài đặt',
          subtitle: 'Tùy chỉnh và các thiết lập khác',
          icon: Icons.settings_outlined,
          onTap: () => Get.toNamed(AppRoutes.settings),
        ),
        ProfileOptionCard(
          title: 'Trợ giúp & Hỗ trợ',
          subtitle: 'Nhận trợ giúp hoặc liên hệ với bộ phận hỗ trợ',
          icon: Icons.help_outlined,
          onTap: () => Get.toNamed(AppRoutes.helpSupport),
        ),
        ProfileOptionCard(
          title: 'Đăng xuất',
          subtitle: 'Thoát khỏi tài khoản của bạn',
          icon: Icons.logout,
          onTap: () async {
            final confirm = await AppDialogs.showLogoutDialog();
            if (confirm == true) {
              context.read<AuthBloc>().add(LogoutRequested());
            }
          },
          isDestructive: true,
        ),
      ],
    );
  }
}
