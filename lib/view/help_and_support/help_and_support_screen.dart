import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/help_and_support/widgets/contact_tile.dart';
import 'package:elearning_app/view/help_and_support/widgets/faq_tile.dart';
import 'package:elearning_app/view/help_and_support/widgets/help_search_bar.dart';
import 'package:elearning_app/view/help_and_support/widgets/help_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelpSearchBar(),
              const SizedBox(height: 24),
              const HelpSection(
                title: 'Frequently Asked Questions',
                children: [
                  FaqTile(
                    questions: 'How do I reset my password?',
                    answer:
                        'Go to the login screen and tap on "Forgot Password". Follow the instructions sent to your email.',
                  ),

                  FaqTile(
                    questions: 'How do I download courses for offline viewing?',
                    answer:
                        'Open a course and tap the download icon. Make sure you have enough storage space.',
                  ),

                  FaqTile(
                    questions: 'Can I get a refund?',
                    answer:
                        'Yes, within 30 days of purchase if you’re not satisfied with the course. Please contact our support team for assistance.',
                  ),

                  FaqTile(
                    questions: 'Are there any free courses available?',
                    answer:
                        'Yes! We offer a selection of free courses that you can access without payment or subscription.',
                  ),

                  FaqTile(
                    questions: 'Can I access my courses on multiple devices?',
                    answer:
                        'Yes, you can log in using the same account across multiple devices, including mobile and desktop.',
                  ),

                  FaqTile(
                    questions: 'Will my progress sync between devices?',
                    answer:
                        'Absolutely! Your progress, notes, and quiz results are automatically synced across all your devices.',
                  ),

                  FaqTile(
                    questions: 'Do courses come with a certificate?',
                    answer:
                        'Yes, upon completing a course, you will receive a digital certificate that you can download or share.',
                  ),

                  FaqTile(
                    questions: 'How do I contact support?',
                    answer:
                        'You can reach our support team via the "Help & Support" section in the app or email us at support@example.com.',
                  ),

                  FaqTile(
                    questions: 'Can instructors update course content?',
                    answer:
                        'Yes, instructors can update or add new lessons anytime. You’ll automatically get access to all updates.',
                  ),

                  FaqTile(
                    questions: 'Do courses expire after purchase?',
                    answer:
                        'No, once you purchase a course, you get lifetime access unless stated otherwise on the course page.',
                  ),

                  FaqTile(
                    questions: 'Can I share my account with others?',
                    answer:
                        'No, sharing accounts is against our Terms of Service. Each account is for individual use only.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              HelpSection(
                title: 'Contact Us',
                children: [
                  ContactTile(
                    title: 'Email Support',
                    subtitle: 'Get help via email',
                    icon: Icons.email_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Live Chat',
                    subtitle: 'Chat with our support team',
                    icon: Icons.chat_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Call Us',
                    subtitle: 'Speak with a representative',
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
