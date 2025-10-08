import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/auth/login_screen.dart';
import 'package:elearning_app/view/home/home_screen.dart';
import 'package:elearning_app/view/onboarding/onboarding_screen.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash, page: () => const SplashScreen(),
    ),
     GetPage(
      name: AppRoutes.onboarding, page: () => const OnboardingScreen(),
    ),
     GetPage(
      name: AppRoutes.home, page: () => const HomeScreen(),
    ),
     GetPage(
      name: AppRoutes.login, page: () => const LoginScreen(),
    )
  ];
}