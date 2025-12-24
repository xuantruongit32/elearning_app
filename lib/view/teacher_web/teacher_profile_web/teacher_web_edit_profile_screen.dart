import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/bloc/profile/profile_event.dart';
import 'package:elearning_app/bloc/profile/profile_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_button.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:elearning_app/view/profile/widgets/profile_picture_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TeacherWebEditProfileScreen extends StatefulWidget {
  const TeacherWebEditProfileScreen({super.key});

  @override
  State<TeacherWebEditProfileScreen> createState() =>
      _TeacherWebEditProfileScreenState();
}

class _TeacherWebEditProfileScreenState
    extends State<TeacherWebEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _fullNameController.text = profile.fullName;
      _phoneController.text = profile.phoneNumber ?? '';
      _bioController.text = profile.bio ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileRequested(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          bio: _bioController.text.trim(),
        ),
      );

      context
          .read<ProfileBloc>()
          .stream
          .firstWhere(((state) => !state.isLoading))
          .then((_) => Get.back());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(color: AppColors.accent),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.accent),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'LƯU',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          if (profile == null)
            return const Center(child: CircularProgressIndicator());

          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildPhotoSection(state, profile),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildFormCard(profile),
                            const SizedBox(height: 24),
                            _buildBioCard(),
                            const SizedBox(height: 32),
                            CustomButton(
                              text: 'Cập nhật thông tin',
                              onPressed: _handleSave,
                              isLoading: state.isLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoSection(ProfileState state, profile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Stack(
              children: [
                state.isPhotoUploading
                    ? Shimmer.fromColors(
                        baseColor: AppColors.primary.withOpacity(0.3),
                        highlightColor: AppColors.accent,
                        child: const CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: profile.photoUrl != null
                            ? NetworkImage(profile.photoUrl!)
                            : null,
                        child: profile.photoUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const ProfilePictureBottomSheet(),
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ảnh đại diện',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Khuyên dùng ảnh định dạng .jpg hoặc .png',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(profile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin cơ bản',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Họ và tên',
              prefixIcon: Icons.person_outline,
              controller: _fullNameController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Email (Không thể thay đổi)',
              prefixIcon: Icons.email_outlined,
              initialValue: profile.email,
              enabled: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Số điện thoại',
              prefixIcon: Icons.phone_outlined,
              controller: _phoneController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giới thiệu chuyên môn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Mô tả ngắn về kinh nghiệm của bạn',
              prefixIcon: Icons.history_edu,
              maxLines: 4,
              controller: _bioController,
            ),
          ],
        ),
      ),
    );
  }
}
