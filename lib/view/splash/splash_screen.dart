import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_state.dart';
import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _hasNavigated = false;
  bool _animationDone = false;
  bool _authReady = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationDone = true;
        });
        _navigate();
      }
    });

    _animationController.forward();


    final initialState = context.read<AuthBloc>().state;
    if (!initialState.isLoading) {
      setState(() {
        _authReady = true;
      });
    }

  }

  void _navigate() {
    if (_animationDone && _authReady && !_hasNavigated) {
      if (!mounted) return;
      _hasNavigated = true;

      final authState = context.read<AuthBloc>().state;

      if (StorageService.isFirstTime()) {
        StorageService.setFirstTime(false);
        Get.offNamed(AppRoutes.onboarding);
      } else if (authState.userModel != null) {
        if (authState.userModel!.role == UserRole.teacher) {
          Get.offNamed(AppRoutes.teacherHome);
        } else {
          Get.offNamed(AppRoutes.main);
        }
      } else {
        Get.offNamed(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!state.isLoading && !_authReady) {
          setState(() {
            _authReady = true;
          });
          _navigate(); 
        }
      },
      child: Scaffold(
        body: Container(
          color: theme.colorScheme.primary,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school,
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Text(
                            'TT Elearning', 
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: theme.colorScheme.surface,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Học thông minh, sống tự do',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.surface.withOpacity(0.7),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.surface,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}