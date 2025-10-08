import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/onboarding/widgets/onboarding_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:elearning_app/models/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
int _currentPage = 0;

final List<OnboardingItem> _pages = [
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding1.png', 
    title: 'Learn Anywhere',
    description:
        'Access your courses anytime, anywhere. Learn at your own pace with our flexible learning platform.',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding2.png',
    title: 'Interactive Learning',
    description:
        'Engage with interactive quizzes, live sessions, and hands-on projects to enhance your learning experience.',
  ),
  OnboardingItem(
    image: 'assets/images/onboarding/onboarding3.png',
    title: 'Track Progress',
    description:
        'Monitor your progress, earn certificates, and achieve your learning goals with detailed analytics and reports.',
  ),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: AppColors.primary,
  body: Stack(
    children: [
      // Page view
      PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index){
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index){
          return OnboardingPageWidget(page: _pages[index]);
        }, 
      ),
    ],
  ),
); 
  }
}