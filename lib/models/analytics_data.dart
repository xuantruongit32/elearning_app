class AnalyticsData {
  final double completionRate;
  final int totalTimeSpent;
  final double averageQuizScore;
  final Map<String, double> skillProgress;
  final List<String> recommendations;
  final List<WeeklyProgress> weeklyProgress;
  final Map<String, int> learningStreak;
  final int totalCoursesEnrolled;
  final int certificatesEarned;

  AnalyticsData({
    required this.completionRate,
    required this.totalTimeSpent,
    required this.averageQuizScore,
    required this.skillProgress,
    required this.recommendations,
    required this.weeklyProgress,
    required this.learningStreak,
    required this.totalCoursesEnrolled,
    required this.certificatesEarned,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      completionRate: json['completionRate'] ?? 0.0,
      totalTimeSpent: json['totalTimeSpent'] ?? 0.0,
      averageQuizScore: json['averageQuizScore'] ?? 0.0,
      skillProgress: Map<String, double>.from(json['skillProgress'] ?? {}),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      weeklyProgress: List<WeeklyProgress>.from(
        json['weeklyProgress']?.map(
          (e) => WeeklyProgress(e['day'], e['minutes']),
        ),
      ),
      learningStreak: Map<String, int>.from(json['learningStreak'] ?? {}),
      totalCoursesEnrolled: json['totalCoursesEnrolled'] ?? 0,
      certificatesEarned: json['certificatesEarned'] ?? 0,
    );
  }
}

class WeeklyProgress {
  final String day;
  final int minutes;

  WeeklyProgress(this.day, this.minutes);
}
