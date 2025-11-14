import 'package:elearning_app/models/analytics_data.dart';

class AnalyticsService {
  Future<AnalyticsData> getUserAnalytics(String userId) async {
    return AnalyticsData(
      completionRate: 0.72,
      totalTimeSpent: 4320,
      averageQuizScore: 88.5,
      skillProgress: {
        'Flutter': 0.85,
        'Dart': 0.75,
        'Thiết kế UI': 0.68,
        'Quản lý dữ liệu': 0.62,
        'Testing': 0.45,
      },
      recommendations: [
        'Hoàn thành "Quản lý trạng thái nâng cao" để cải thiện kiến trúc ứng dụng',
        'Tham gia workshop UI/UX để nâng cao kỹ năng thiết kế',
        'Luyện tập thêm về kiểm thử Flutter để tăng chất lượng test',
      ],
      weeklyProgress: [
        WeeklyProgress('T2', 45),
        WeeklyProgress('T3', 60),
        WeeklyProgress('T4', 30),
        WeeklyProgress('T5', 75),
        WeeklyProgress('T6', 50),
        WeeklyProgress('T7', 90),
        WeeklyProgress('CN', 40),
      ],
      learningStreak: {'current': 5, 'longest': 12, 'total': 45},
      totalCoursesEnrolled: 8,
      certificatesEarned: 3,
    );
  }

  Future<AnalyticsData> updateCourseProgress(
    String userId,
    String courseId,
    double progress,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AnalyticsData(
      completionRate: (currentAnalytics.completionRate + progress) / 2,
      totalTimeSpent: currentAnalytics.totalTimeSpent + 30,
      averageQuizScore: currentAnalytics.averageQuizScore,
      skillProgress: currentAnalytics.skillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: currentAnalytics.learningStreak,
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned,
    );
  }

  Future<AnalyticsData> updateQuizScore(
    String userId,
    String quizId,
    double score,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AnalyticsData(
      completionRate: currentAnalytics.completionRate,
      totalTimeSpent: currentAnalytics.totalTimeSpent,
      averageQuizScore: (currentAnalytics.averageQuizScore + score) / 2,
      skillProgress: currentAnalytics.skillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: currentAnalytics.learningStreak,
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned,
    );
  }

  Future<AnalyticsData> updateLearningStreak(
    String userId,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final currentStreak = currentAnalytics.learningStreak['current']! + 1;
    final longestStreak =
        currentStreak > currentAnalytics.learningStreak['longest']!
        ? currentStreak
        : currentAnalytics.learningStreak['longest']!;

    return AnalyticsData(
      completionRate: currentAnalytics.completionRate,
      totalTimeSpent: currentAnalytics.totalTimeSpent,
      averageQuizScore: currentAnalytics.averageQuizScore,
      skillProgress: currentAnalytics.skillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: {
        'current': currentStreak,
        'longest': longestStreak,
        'total': currentAnalytics.learningStreak['total']! + 1,
      },
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned,
    );
  }

  Future<AnalyticsData> updateSkillProgress(
    String userId,
    String skillName,
    double progress,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updatedSkillProgress = Map<String, double>.from(
      currentAnalytics.skillProgress,
    );
    updatedSkillProgress[skillName] = progress;

    return AnalyticsData(
      completionRate: currentAnalytics.completionRate,
      totalTimeSpent: currentAnalytics.totalTimeSpent,
      averageQuizScore: currentAnalytics.averageQuizScore,
      skillProgress: updatedSkillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: currentAnalytics.learningStreak,
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned,
    );
  }

  Future<AnalyticsData> completeLesson(
    String userId,
    String courseId,
    String lessonId,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AnalyticsData(
      completionRate: currentAnalytics.completionRate + 0.05,
      totalTimeSpent: currentAnalytics.totalTimeSpent + 45,
      averageQuizScore: currentAnalytics.averageQuizScore,
      skillProgress: currentAnalytics.skillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: currentAnalytics.learningStreak,
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned,
    );
  }

  Future<AnalyticsData> earnCertificate(
    String userId,
    String courseId,
    AnalyticsData currentAnalytics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AnalyticsData(
      completionRate: currentAnalytics.completionRate,
      totalTimeSpent: currentAnalytics.totalTimeSpent,
      averageQuizScore: currentAnalytics.averageQuizScore,
      skillProgress: currentAnalytics.skillProgress,
      recommendations: currentAnalytics.recommendations,
      weeklyProgress: currentAnalytics.weeklyProgress,
      learningStreak: currentAnalytics.learningStreak,
      totalCoursesEnrolled: currentAnalytics.totalCoursesEnrolled,
      certificatesEarned: currentAnalytics.certificatesEarned + 1,
    );
  }
}
