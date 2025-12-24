// main.dart

import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_state.dart';
import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/font/font_bloc.dart';
import 'package:elearning_app/bloc/font/font_state.dart';
import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/config/firebase_config.dart';
import 'package:elearning_app/core/theme/app_theme.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/routes/route_pages.dart';
import 'package:elearning_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:elearning_app/app_entry.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  await GetStorage.init();
  await StorageService.init();
  // Khởi tạo các service/repository cần thiết
  Get.put<RouteObserver<PageRoute>>(RouteObserver<PageRoute>());
  Get.put(TeacherRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<CourseBloc>(
          create: (context) => CourseBloc(
            authBloc: context.read<AuthBloc>(),
            courseRepository: CourseRepository(),
          ),
        ),
        BlocProvider<FilteredCourseBloc>(
          create: (context) => FilteredCourseBloc(
            courseRepository: CourseRepository(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      // XÓA BlocListener ở đây đi, đưa nó vào bên trong home
      child: BlocBuilder<FontBloc, FontState>(
        builder: (context, fontState) {
          final routeObserver = Get.find<RouteObserver<PageRoute>>();
          return GetMaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: 'TT Elearning',
            theme: AppTheme.getLightTheme(fontState),
            themeMode: ThemeMode.light,
            locale: const Locale('vi', 'VN'),
            supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // SỬA: Đặt BlocListener bọc lấy AppEntry (Widget con của MaterialApp)
            home: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.error != null) {
                  // Bây giờ context này đã nằm dưới GetMaterialApp
                  // nên ScaffoldMessenger và Get.snackbar sẽ hoạt động
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const AppEntry(),
            ),

            onGenerateRoute: AppRoutes.onGenerateRoute,
            getPages: AppPages.pages,
            navigatorObservers: [routeObserver],
          );
        },
      ),
    );
  }
}
