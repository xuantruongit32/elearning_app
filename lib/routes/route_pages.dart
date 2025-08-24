import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash, page: () => const SplashScreen(),
    )
  ];
}