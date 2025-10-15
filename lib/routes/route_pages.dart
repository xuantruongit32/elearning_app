import 'package:elearning_app/main_screen.dart';
import 'package:elearning_app/models/quiz.dart';
import 'package:elearning_app/models/quiz_attempt.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/auth/forgot_password_screen.dart';
import 'package:elearning_app/view/auth/login_screen.dart';
import 'package:elearning_app/view/auth/register_screen.dart';
import 'package:elearning_app/view/chat/chat_list_screen.dart';
import 'package:elearning_app/view/course/course_detail/course_detail_screen.dart';
import 'package:elearning_app/view/course/course_list/course_list_screen.dart';
import 'package:elearning_app/view/course/lesson_screen/lesson_screen.dart';
import 'package:elearning_app/view/course/payment/payment_screen.dart';
import 'package:elearning_app/view/home/home_screen.dart';
import 'package:elearning_app/view/notifications/notifications_screen.dart';
import 'package:elearning_app/view/onboarding/onboarding_screen.dart';
import 'package:elearning_app/view/profile/profile_screen.dart';
import 'package:elearning_app/view/quiz/quiz_attempt/quiz_attempt_screen.dart';
import 'package:elearning_app/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:elearning_app/view/quiz/quiz_result/quiz_result_screen.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:elearning_app/view/teacher/my_courses/my_courses_screen.dart';
import 'package:elearning_app/view/teacher/teacher_home/teacher_home_screen.dart';
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
    GetPage(name: AppRoutes.teacherChats, page: () => const ChatListScreen()),

    GetPage(name: AppRoutes.myCourses, page: () => const MyCoursesScreen()),

    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
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
  ];
}
