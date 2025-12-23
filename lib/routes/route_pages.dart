import 'package:elearning_app/main_screen.dart';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/admin/admin_screen.dart';
import 'package:elearning_app/view/auth/forgot_password_screen.dart';
import 'package:elearning_app/view/auth/login_screen.dart';
import 'package:elearning_app/view/auth/register_screen.dart';
import 'package:elearning_app/view/chat/chat_list_screen.dart';
import 'package:elearning_app/view/course/analytics_dashboard/analytics_dashboard_screen.dart';
import 'package:elearning_app/view/course/course_detail/course_detail_screen.dart';
import 'package:elearning_app/view/course/course_list/course_list_screen.dart';
import 'package:elearning_app/view/course/course_search/course_search_screen.dart';
import 'package:elearning_app/view/course/lesson_screen/lesson_screen.dart';
import 'package:elearning_app/view/course/payment/payment_screen.dart';
import 'package:elearning_app/view/help_and_support/help_and_support_screen.dart';
import 'package:elearning_app/view/home/home_screen.dart';
import 'package:elearning_app/view/notifications/notifications_screen.dart';
import 'package:elearning_app/view/onboarding/onboarding_screen.dart';
import 'package:elearning_app/view/privacy_&_terms_conditions/privacy_policy_screen.dart';
import 'package:elearning_app/view/privacy_&_terms_conditions/terms_conditions_screen.dart';
import 'package:elearning_app/view/profile/edit_profile_screen.dart';
import 'package:elearning_app/view/profile/profile_screen.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/quiz_attempt_screen.dart';
import 'package:elearning_app/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:elearning_app/view/quiz/quiz_result/quiz_result_screen.dart';
import 'package:elearning_app/view/settings/settings_screen.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:elearning_app/view/teacher/create_course/create_course_screen.dart';
import 'package:elearning_app/view/teacher/my_courses/my_courses_screen.dart';
import 'package:elearning_app/view/teacher/payment/teacher_payment_screen.dart';
import 'package:elearning_app/view/teacher/student_progress/student_progress_screen.dart';
import 'package:elearning_app/view/teacher/teacher_analytics/teacher_analytics_screen.dart';
import 'package:elearning_app/view/teacher/teacher_home/teacher_home_screen.dart';
import 'package:elearning_app/view/teacher_web/create_course_web/create_course_screen_web.dart';
import 'package:elearning_app/view/teacher_web/my_course_screen_web/my_course_screen_web.dart';
import 'package:elearning_app/view/teacher_web/payment_web/teacher_payment_web.dart';
import 'package:elearning_app/view/teacher_web/teacher_analytics_web/teacher_analytics_web_screen.dart';
import 'package:elearning_app/view/teacher_web/teacher_web_home/teacher_web_home_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(name: AppRoutes.teacherHome, page: () => const TeacherHomeScreen()),
    GetPage(
      name: AppRoutes.teacherWebHome,
      page: () => const TeacherWebHomeScreen(),
    ),

    GetPage(name: AppRoutes.teacherChats, page: () => const ChatListScreen()),

    GetPage(name: AppRoutes.myCourses, page: () => const MyCoursesScreen()),
    GetPage(
      name: AppRoutes.myCoursesWeb,
      page: () => const MyCoursesScreenWeb(),
    ),

    GetPage(
      name: AppRoutes.createCourse,
      page: () => const CreateCourseScreen(),
    ),
    GetPage(
      name: AppRoutes.createCourseWeb,
      page: () => const CreateCourseScreenWeb(),
    ),
    GetPage(
      name: AppRoutes.teacherPayments,
      page: () => const TeacherPaymentsScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherPaymentsWeb,
      page: () => const TeacherPaymentWebScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherAnalytics,
      page: () => const TeacherAnalyticsScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherAnalyticsWeb,
      page: () => const TeacherAnalyticsWebScreen(),
    ),
    GetPage(
      name: AppRoutes.courseSearch,
      page: () => const CourseSearchScreen(),
    ),
    GetPage(
      name: AppRoutes.studentProgress,
      page: () => const StudentProgressScreen(),
    ),
    GetPage(name: AppRoutes.analytics, page: () => AnalyticsDashboardScreen()),

    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsConditions,
      page: () => const TermsConditionsScreen(),
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpAndSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.courseList,
      page: () => CourseListScreen(
        categoryId: Get.arguments?['category'] as String?,
        categoryName: Get.arguments?['categoryName'] as String?,
      ),
    ),
    GetPage(
      name: '/course/:id',
      page: () => CourseDetailScreen(courseId: Get.parameters['id'] ?? ''),
    ),

    GetPage(name: AppRoutes.quizList, page: () => const QuizListScreen()),
    GetPage(
      name: '/quiz/:id',
      page: () => QuizAttemptScreen(quizId: Get.parameters['id'] ?? ''),
    ),
    GetPage(
      name: '/quiz/:id',
      page: () => QuizResultScreen(
        attempt: Get.arguments['attempt'] as QuizAttempt,
        quiz: Get.arguments['quiz'] as Quiz,
      ),
    ),

    GetPage(
      name: AppRoutes.lesson,
      page: () => LessonScreen(lessonId: Get.parameters['id'] ?? ''),
    ),

    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentScreen(
        courseId: Get.arguments['courseId'] as String,
        courseName: Get.arguments['courseName'] as String,
        price: Get.arguments['price'] as double,
      ),
    ),

    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(
        initialIndex: Get.arguments is Map<String, dynamic>
            ? Get.arguments['initialIndex'] as int?
            : null,
      ),
    ),
    GetPage(name: AppRoutes.admin, page: () => const AdminLayout()),
  ];
}
