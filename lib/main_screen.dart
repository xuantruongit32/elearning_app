import 'package:elearning_app/bloc/navigation/navigation_bloc.dart';
import 'package:elearning_app/bloc/navigation/navigation_event.dart';
import 'package:elearning_app/bloc/navigation/navigation_state.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/course/course_list/course_list_screen.dart';
import 'package:elearning_app/view/home/home_screen.dart';
import 'package:elearning_app/view/profile/profile_screen.dart';
import 'package:elearning_app/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  final int? initialIndex;
  const MainScreen({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NavigationBloc()..add(NavigateToTab(initialIndex ?? 0)),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: IndexedStack(
              index: state.currentIndex,
              children: [
                HomeScreen(),
                CourseListScreen(),
                QuizListScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: AppColors.accent,
              indicatorColor: AppColors.primary.withValues(alpha: 0.1),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                NavigationDestination(
                  icon: Icon(Icons.play_lesson_outlined),
                  selectedIcon: Icon(Icons.play_lesson),
                  label: 'Khóa học',
                ),
                NavigationDestination(
                  icon: Icon(Icons.quiz_outlined),
                  selectedIcon: Icon(Icons.quiz),
                  label: 'Kiểm tra',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outlined),
                  selectedIcon: Icon(Icons.person),
                  label: 'Hồ sơ',
                ),
              ],
              selectedIndex: state.currentIndex,
              onDestinationSelected: (index) {
                context.read<NavigationBloc>().add(NavigateToTab(index));
              },
            ),
          );
        },
      ),
    );
  }
}
