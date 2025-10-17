import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_button.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:elearning_app/view/profile/widgets/edit_profile_app_bar.dart';
import 'package:elearning_app/view/profile/widgets/profile_picture_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditProfileAppBar(
        onSave: () {
          //save profile change
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          //profile picture with gradient backgr
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.accent,
                          child: Text(
                            "T",
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.accent,
                            radius: 20,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) =>
                                      const ProfilePictureBottomSheet(),
                                );
                              },
                              color: AppColors.primary,
                              icon: const Icon(Icons.camera_alt, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Edit Your Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 4),
                    child: Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //forms in card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
                children: [
                  CustomTextField(
                    label: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    initialValue: 'Hoang Truong',
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    initialValue: 'truong@gmail.com',
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: 'Phone',
                    prefixIcon: Icons.phone_outlined,
                    initialValue: '+84349168533',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            //Bio
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 4),
              child: Text(
                'About You',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: const CustomTextField(
                label: 'Bio',
                prefixIcon: Icons.info_outline,
                initialValue: 'IT student at Phenikaa University.',
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {
                //save profile
                Get.back();
              },
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }
}
