import 'package:elearning_app/bloc/font/font_bloc.dart';
import 'package:elearning_app/bloc/font/font_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/font_service.dart';
import 'package:elearning_app/view/settings/widgets/setting_tile.dart';
import 'package:elearning_app/view/settings/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingSection(
                title: 'Tùy chọn',
                children: [
                  SettingTile(
                    title: 'Chỉ tải xuống qua Wi-Fi',
                    icon: Icons.wifi_outlined,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Nội dung',
                children: [
                  SettingTile(
                    title: 'Chất lượng tải xuống',
                    icon: Icons.high_quality_outlined,
                    trailing: DropdownButton<String>(
                      onChanged: (value) {},
                      underline: const SizedBox(),
                      value: 'Cao',
                      items: ['Thấp', 'Trung bình', 'Cao']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                    ),
                  ),
                  SettingTile(
                    title: 'Tự động phát video',
                    icon: Icons.play_circle_outlined,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Quyền riêng tư',
                children: [
                  SettingTile(
                    title: 'Chính sách bảo mật',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                  ),
                  SettingTile(
                    title: 'Điều khoản dịch vụ',
                    icon: Icons.description_outlined,
                    onTap: () => Get.toNamed(AppRoutes.termsConditions),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Cài đặt văn bản',
                children: [
                  SettingTile(
                    title: 'Kích thước chữ',
                    icon: Icons.format_size,
                    trailing: DropdownButton<String>(
                      value: FontService.currentFontScale == 0.8
                          ? 'Nhỏ'
                          : FontService.currentFontScale == 1.0
                          ? 'Bình thường'
                          : FontService.currentFontScale == 1.2
                          ? 'Lớn'
                          : 'Rất lớn',
                      items:
                          {
                                'Nhỏ': 0.8,
                                'Bình thường': 1.0,
                                'Lớn': 1.2,
                                'Rất lớn': 1.4,
                              }.keys
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          context.read<FontBloc>().add(
                            UpdateFontScale(
                              {
                                'Nhỏ': 0.8,
                                'Bình thường': 1.0,
                                'Lớn': 1.2,
                                'Rất lớn': 1.4,
                              }[value]!,
                            ),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  SettingTile(
                    title: 'Phông chữ',
                    icon: Icons.font_download,
                    trailing: DropdownButton<String>(
                      value: FontService.availableFonts.entries
                          .firstWhere(
                            (e) => e.value == FontService.currentFontFamily,
                          )
                          .key,
                      items: FontService.availableFonts.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          context.read<FontBloc>().add(
                            UpdateFontFamily(
                              FontService.availableFonts[value]!,
                            ),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Thông tin ứng dụng',
                children: [
                  SettingTile(
                    title: 'Phiên bản',
                    icon: Icons.info_outline,
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
