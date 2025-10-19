import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/bloc/profile/profile_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureBottomSheet extends StatelessWidget {
  const ProfilePictureBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (!context.mounted) return;

      //close bottom sheet after selected
      Navigator.pop(context);

      //start upload process
      final bloc = context.read<ProfileBloc>();
      bloc.add(UpdateProfilePhotoRequested(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Profile Picture',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.photo_library, color: Colors.white),
            ),
            title: const Text('Choose from Gallery'),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            title: const Text('Take a photo'),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.delete_outline, color: Colors.white),
            ),
            title: const Text(
              'Remove photo',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              // TODO: Remove photo
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
