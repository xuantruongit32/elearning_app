import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/bloc/profile/profile_event.dart';
import 'package:elearning_app/bloc/profile/profile_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/profile/widgets/profile_app_bar.dart';
import 'package:elearning_app/view/profile/widgets/profile_options.dart';
import 'package:elearning_app/view/profile/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    //load profile only once when screen is first create
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const Scaffold(body: Center(child: Text('Profile not found')));
        }
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              ProfileAppBar(
                nickname: profile.fullName
                    .split(' ')
                    .map((e) => e[0])
                    .take(2)
                    .join()
                    .toUpperCase(),
                fullName: profile.fullName,
                email: profile.email,
                photoUrl: profile.photoUrl,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Column(
                    children: [
                      ProfileStatsCard(),
                      SizedBox(height: 24),
                      ProfileOptions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
