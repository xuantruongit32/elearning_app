import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_state.dart';
import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/font/font_bloc.dart';
import 'package:elearning_app/bloc/font/font_state.dart';
import 'package:elearning_app/bloc/profile/profile_bloc.dart';
import 'package:elearning_app/config/firebase_config.dart';
import 'package:elearning_app/core/theme/app_theme.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/routes/route_pages.dart';
import 'package:elearning_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  await GetStorage.init();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FontBloc>(create: (context) => FontBloc()), // BlocProvider
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
          create: (context) =>
              FilteredCourseBloc(courseRepository: CourseRepository()),
        ),
        
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<FontBloc, FontState>(
          builder: (context, fontState) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E-Learning App',
              theme: AppTheme.getLightTheme(fontState),
              themeMode: ThemeMode.light,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              getPages: AppPages.pages,
            );
          },
        ),
      ),
    );
  }
}
