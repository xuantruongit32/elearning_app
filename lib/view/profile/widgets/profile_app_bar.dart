import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/bloc/profile/profile_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAppBar extends StatelessWidget {
  final String nickname;
  final String fullName;
  final String email;
  final String? photoUrl;
  const ProfileAppBar({
    super.key,
    required this.nickname,
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state.isPhotoUploading) {
                      return Shimmer.fromColors(
                        baseColor: AppColors.primary.withValues(alpha: 0.3),
                        highlightColor: AppColors.accent,
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.lightSurface,
                      backgroundImage: photoUrl != null
                          ? CachedNetworkImageProvider(photoUrl!)
                          : null,
                      child: photoUrl == null
                          ? Text(
                              nickname,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.accent.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
