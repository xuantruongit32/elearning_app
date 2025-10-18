import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/privacy_&_terms_conditions/widgets/legal_document_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 15, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            const LegalDocumentSection(
              title: "1. Acceptance of Terms",
              content:
                  "By accessing or using our services, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree, you must not use our platform.",
            ),

            const LegalDocumentSection(
              title: "2. User Accounts",
              content:
                  "To access certain features, you may need to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.",
            ),

            const LegalDocumentSection(
              title: "3. Course Content",
              content:
                  "All courses, videos, and materials provided on our platform are for personal learning use only. You may not copy, distribute, or resell any content without written permission.",
            ),

            const LegalDocumentSection(
              title: "4. Payment Terms",
              content:
                  "All payments for courses or subscriptions must be made through approved methods. Fees are non-refundable except as required by law or stated otherwise in specific promotions.",
            ),

            const LegalDocumentSection(
              title: "5. Intellectual Property",
              content:
                  "All content, including text, graphics, logos, and software, is owned by or licensed to us. You may not reproduce, modify, or exploit any part of the platform without prior consent.",
            ),

            const LegalDocumentSection(
              title: "6. Prohibited Activities",
              content:
                  "You agree not to misuse the platform, including but not limited to hacking, data mining, spreading malware, or engaging in activities that disrupt the experience of other users.",
            ),

            const LegalDocumentSection(
              title: "7. Termination",
              content:
                  "We reserve the right to suspend or terminate your account if you violate these Terms or engage in fraudulent, abusive, or illegal behavior on the platform.",
            ),

            const LegalDocumentSection(
              title: "8. Limitation of Liability",
              content:
                  "We are not liable for any indirect, incidental, or consequential damages arising from your use of our platform. Use the service at your own risk.",
            ),

            const LegalDocumentSection(
              title: "9. Changes to Terms",
              content:
                  "We may update these Terms and Conditions periodically. Continued use of the platform after changes constitutes acceptance of the new terms.",
            ),

            const LegalDocumentSection(
              title: "10. Contact Information",
              content:
                  "If you have any questions or concerns about these Terms and Conditions, please contact us at: support@example.com.",
            ),
          ],
        ),
      ),
    );
  }
}
