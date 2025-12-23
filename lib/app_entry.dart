// lib/app_entry.dart

import 'package:elearning_app/view/auth/web_login_screen.dart';
import 'package:elearning_app/view/splash/splash_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// 1. Import màn hình Splash (cho mobile)

// 2. Import màn hình Web Login (cho web)
// (Hãy đảm bảo đường dẫn này đúng với file bạn tạo ở bước trước)

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // kIsWeb là một biến đặc biệt của Flutter
    // Nó sẽ là 'true' nếu bạn đang chạy trên trình duyệt web
    // và 'false' nếu bạn chạy trên iOS hoặc Android.

    if (kIsWeb) {
      // NẾU LÀ WEB -> Chuyển đến màn hình đăng nhập của Web
      return const WebLoginScreen();
    } else {
      // NẾU LÀ APP -> Chuyển đến màn hình SplashScreen (luồng cũ)
      return const SplashScreen();
    }
  }
}
