// lib/view/web/web_login_screen.dart

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/bloc/auth/auth_event.dart';
import 'package:elearning_app/bloc/auth/auth_state.dart';
import 'package:elearning_app/core/utils/validators.dart';
import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_button.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (state.userModel != null) {
          final userRole = state.userModel!.role;

          if (userRole == UserRole.admin) {
            // CHUYỂN HƯỚNG ADMIN
            Get.offAllNamed(AppRoutes.admin);
          } else if (userRole == UserRole.teacher) {
            Get.offAllNamed(AppRoutes.teacherWebHome);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tài khoản của bạn không có quyền truy cập.'),
                backgroundColor: Colors.orange,
              ),
            );
            context.read<AuthBloc>().add(LogoutRequested());
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hệ Thống Quản Lý',
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Dành cho Quản trị viên & Giáo viên',
                          style: Get.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 32),

                        CustomTextField(
                          label: 'Email',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: FormValidator.validateEmail,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Mật khẩu',
                          prefixIcon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: true,
                          validator: FormValidator.validatePassword,
                        ),
                        const SizedBox(height: 32),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: 'Đăng nhập',
                              onPressed: _handleLogin,
                              isLoading: state.isLoading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
