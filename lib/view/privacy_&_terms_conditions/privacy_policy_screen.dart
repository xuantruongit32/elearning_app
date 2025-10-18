import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/privacy_&_terms_conditions/widgets/legal_document_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              title: "1. Information We Collect",
              content:
                  "We collect information that you provide directly to us, including but not limited to your name, email address, phone number, payment details, and any other data you choose to share when using our services.",
            ),

            const LegalDocumentSection(
              title: "2. How We Use Your Information",
              content:
                  "We use your information to provide, maintain, and improve our services, process transactions, send updates or promotional materials, and ensure a personalized experience. We may also use data for analytics, research, and to enhance security.",
            ),

            const LegalDocumentSection(
              title: "3. Data Security",
              content:
                  "We implement appropriate technical and organizational measures to protect your data from unauthorized access, loss, misuse, or alteration. However, please note that no method of transmission over the internet is 100% secure.",
            ),

            const LegalDocumentSection(
              title: "4. Your Rights",
              content:
                  "You have the right to access, correct, or delete your personal data. You may also withdraw consent or object to certain processing activities, in accordance with applicable data protection laws.",
            ),

            const LegalDocumentSection(
              title: "5. Data Retention",
              content:
                  "We retain your personal information only as long as necessary to fulfill the purposes outlined in this policy, comply with legal obligations, resolve disputes, and enforce agreements.",
            ),

            const LegalDocumentSection(
              title: "6. Third-Party Services",
              content:
                  "Our services may contain links or integrations with third-party platforms. We are not responsible for the privacy practices of such third parties, and we encourage you to review their respective privacy policies.",
            ),

            const LegalDocumentSection(
              title: "7. Cookies and Tracking Technologies",
              content:
                  "We use cookies and similar technologies to enhance user experience, analyze site traffic, and deliver personalized content. You may control cookie settings through your browser preferences.",
            ),

            const LegalDocumentSection(
              title: "8. Children’s Privacy",
              content:
                  "Our services are not intended for children under the age of 13. We do not knowingly collect personal data from minors. If you believe a child has provided us with personal information, please contact us for deletion.",
            ),

            const LegalDocumentSection(
              title: "9. Updates to This Policy",
              content:
                  "We may update this Privacy Policy from time to time. The updated version will be posted on this page with a new 'last updated' date. Continued use of our services constitutes acceptance of any changes.",
            ),

            const LegalDocumentSection(
              title: "10. Contact Us",
              content:
                  "If you have any questions, concerns, or requests regarding this Privacy Policy or our data practices, please contact us at: privacy@example.com.",
            ),
          ],
        ),
      ),
    );
  }
}
