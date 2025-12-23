import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/quiz/quiz_list/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(
                'Bài kiểm tra',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final quiz = DummyDataService.quizzes[index];
                return QuizCard(
                  title: quiz.title,
                  description: quiz.description,
                  questionCount: quiz.questions.length,
                  timeLimit: quiz.timeLimit,
                  onTap: () => Get.toNamed(
                    '/quiz/${quiz.id}',
                    parameters: {'id': quiz.id},
                  ),
                );
              }, childCount: DummyDataService.quizzes.length),
            ),
          ),
        ],
      ),
    );
  }
}
