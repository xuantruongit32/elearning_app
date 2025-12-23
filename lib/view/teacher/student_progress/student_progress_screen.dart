import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/dummy_data_service.dart';
import 'package:elearning_app/view/teacher/student_progress/widgets/performance_card.dart';
import 'package:elearning_app/view/teacher/student_progress/widgets/student_progress_app_bar.dart';
import 'package:elearning_app/view/teacher/student_progress/widgets/student_progress_card.dart';
import 'package:flutter/material.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProgress = DummyDataService.getStudentProgress('inst_1');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const StudentProgressAppBar(),
          ],
          body: TabBarView(
            children: [
              _buildCourseProgressTab(studentProgress),
              _buildPerformanceTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    final teacherStats = DummyDataService.getTeacherStats('inst_1');
    final engagement = teacherStats.studentEngagement;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: engagement.courseCompletionRates.length,
      itemBuilder: (context, index) {
        final courseName = engagement.courseCompletionRates.keys.elementAt(
          index,
        );
        final completionRate =
            engagement.courseCompletionRates[courseName] ?? 0.0;
        return PerformanceCard(
          courseName: courseName,
          averageCompletionRate: engagement.averageCompletionRate,
          averageTimePerLesson: engagement.averageTimePerLesson,
          completionRate: completionRate,
        );
      },
    );
  }

  Widget _buildCourseProgressTab(List<StudentProgress> studentProgress) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: studentProgress.length,
      itemBuilder: (context, index) {
        final progress = studentProgress[index];
        return StudentProgressCard(progress: progress);
      },
    );
  }
}
