import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/analytics_service.dart';
import 'package:elearning_app/view/course/analytics_dashboard/widgets/learning_streak_card.dart';
import 'package:elearning_app/view/course/analytics_dashboard/widgets/recommendations_card.dart';
import 'package:elearning_app/view/course/analytics_dashboard/widgets/skills_progress_card.dart';
import 'package:elearning_app/view/course/analytics_dashboard/widgets/weekly_progress_card.dart';
import 'package:flutter/material.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  AnalyticsDashboardScreen({super.key});
  final _analyticsService = AnalyticsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Phân tích quá trình học',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _analyticsService.getUserAnalytics('current_user_id'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final analytics = snapshot.data!;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LearningStreakCard(learningStreak: analytics.learningStreak),
                  const SizedBox(height: 20),
                  WeeklyProgressCard(weeklyProgress: analytics.weeklyProgress),
                  const SizedBox(height: 20),
                  SkillsProgressCard(skillProgress: analytics.skillProgress),
                  const SizedBox(height: 20),
                  RecommendationsCard(
                    recommendations: analytics.recommendations,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
