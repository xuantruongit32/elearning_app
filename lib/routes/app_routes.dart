import 'package:elearning_app/main_screen.dart';
import 'package:elearning_app/view/auth/forgot_password_screen.dart';
import 'package:elearning_app/view/auth/login_screen.dart';
import 'package:elearning_app/view/auth/register_screen.dart';
import 'package:elearning_app/view/chat/chat_list_screen.dart';
import 'package:elearning_app/view/course/analytics_dashboard/analytics_dashboard_screen.dart';
import 'package:elearning_app/view/course/course_detail/course_detail_screen.dart';
import 'package:elearning_app/view/course/course_list/course_list_screen.dart';
import 'package:elearning_app/view/course/lesson_screen/lesson_screen.dart';
import 'package:elearning_app/view/course/payment/payment_screen.dart';
import 'package:elearning_app/view/home/home_screen.dart';
import 'package:elearning_app/view/notifications/notifications_screen.dart';
import 'package:elearning_app/view/onboarding/onboarding_screen.dart';
import 'package:elearning_app/view/privacy_&_terms_conditions/privacy_policy_screen.dart';
import 'package:elearning_app/view/profile/edit_profile_screen.dart';
import 'package:elearning_app/view/profile/profile_screen.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/quiz_attempt_screen.dart';
import 'package:elearning_app/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:elearning_app/view/settings/settings_screen.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:elearning_app/view/teacher/create_course/create_course_screen.dart';
import 'package:elearning_app/view/teacher/my_courses/my_courses_screen.dart';
import 'package:elearning_app/view/teacher/student_progress/student_progress_screen.dart';
import 'package:elearning_app/view/teacher/teacher_analytics/teacher_analytics_screen.dart';
import 'package:elearning_app/view/teacher/teacher_home/teacher_home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  //main
  static const String main = '/main';

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';

  //teacher
  static const String teacherHome = '/teacher/home';
  static const String myCourses = '/teacher/courses';
  static const String teacherChats = '/teacher/chats';
  static const String createCourse = '/teacher/courses/create';
  static const String teacherAnalytics = '/teacher/analytics';
  static const String studentProgress = '/teacher/students';

  //course routes
  static const String courseList = '/courses';
  static const String courseDetail = '/course/:id';
  static const String payment = '/payment';
  static const String lesson = '/lesson:id';
  static const String analytics = '/analytics';

  //quiz routes
  static const String quizList = '/quizzes';
  static const String quizAttempt = '/quiz/:id';
  static const String quizResult = '/quiz/result';

  //profile routes
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacy-policy';

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case main:
        return MaterialPageRoute(
          builder: (_) => MainScreen(
            initialIndex: setting.arguments is Map
                ? (setting.arguments as Map<String, dynamic>)['initialIndex']
                      as int?
                : null,
          ),
        );
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case courseList:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CourseListScreen(
            categoryId: args?['category'] as String?,
            categoryName: args?['categoryName'] as String?,
          ),
        );
      case courseDetail:
        String courseId;
        if (setting.arguments != null) {
          courseId = setting.arguments as String;
        } else {
          final uri = Uri.parse(setting.name ?? '');
          courseId = uri.pathSegments.last;
        }
        return MaterialPageRoute(
          builder: (_) => CourseDetailScreen(courseId: courseId),
        );
      case quizList:
        return MaterialPageRoute(builder: (_) => const QuizListScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => AnalyticsDashboardScreen());
      case studentProgress:
        return MaterialPageRoute(builder: (_) => const StudentProgressScreen());
      case quizAttempt:
        final quizzId = setting.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => QuizAttemptScreen(quizId: quizzId ?? ''),
        );
      case lesson:
        final lessonId = setting.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => LessonScreen(lessonId: lessonId ?? ''),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case teacherHome:
        return MaterialPageRoute(builder: (_) => const TeacherHomeScreen());
      case teacherChats:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case myCourses:
        return MaterialPageRoute(builder: (_) => const MyCoursesScreen());
      case createCourse:
        return MaterialPageRoute(builder: (_) => const CreateCourseScreen());
      case teacherAnalytics:
        return MaterialPageRoute(
          builder: (_) => const TeacherAnalyticsScreen(),
        );
      case payment:
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            courseId: args['courseId'] ?? '',
            courseName: args['courseName'] ?? '',
            price: args['price'] ?? 0.0,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found!'))),
        );
    }
  }
}
