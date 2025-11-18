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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (state.userModel != null) {
          // ========= PHẦN CẬP NHẬT LOGIC ==========
          final userRole = state.userModel!.role;

          if (userRole == UserRole.teacher) {
            // Cho phép Teacher
            Get.offAllNamed(AppRoutes.teacherHome);
          } else if (userRole == UserRole.student) {
            // Cho phép Student
            Get.offAllNamed(AppRoutes.main);
          } else if (userRole == UserRole.admin) {
            // CHẶN ADMIN
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Quản trị viên vui lòng đăng nhập trên trang web.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
            context.read<AuthBloc>().add(LogoutRequested());
          }
        }
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                  ),
                ),
                child: const Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Chào mừng trở lại!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                          const SizedBox(height: 10),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.forgotPassword),
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Login button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Đăng nhập',
                                onPressed: _handleLogin,
                                isLoading: state.isLoading,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Hoặc tiếp tục với'),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialLoginButton(
                          icon: Icons.g_mobiledata,
                          onPressed: () {},
                        ),
                        _socialLoginButton(
                          icon: Icons.facebook,
                          onPressed: () {},
                        ),
                        _socialLoginButton(icon: Icons.apple, onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản?"),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.register),
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      icon: icon,
      isFullWidth: false,
      height: 50,
      text: '',
      onPressed: onPressed,
      isOutlined: true,
    );
  }
}
