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
          'Điều khoản & Điều kiện',
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
              'Cập nhật lần cuối: 15 Tháng 11, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            const LegalDocumentSection(
              title: "1. Chấp nhận Điều khoản",
              content:
                  "Bằng việc truy cập hoặc sử dụng dịch vụ của chúng tôi, bạn đồng ý tuân theo các Điều khoản và Chính sách quyền riêng tư này. Nếu bạn không đồng ý, vui lòng không sử dụng nền tảng của chúng tôi.",
            ),

            const LegalDocumentSection(
              title: "2. Tài khoản người dùng",
              content:
                  "Để truy cập một số tính năng nhất định, bạn có thể cần tạo tài khoản. Bạn chịu trách nhiệm bảo mật thông tin đăng nhập và mọi hoạt động diễn ra trong tài khoản của mình.",
            ),

            const LegalDocumentSection(
              title: "3. Nội dung khóa học",
              content:
                  "Tất cả khóa học, video và tài liệu trên nền tảng chỉ được sử dụng cho mục đích học tập cá nhân. Bạn không được sao chép, phân phối hoặc bán lại bất kỳ nội dung nào nếu không có sự cho phép bằng văn bản.",
            ),

            const LegalDocumentSection(
              title: "4. Điều khoản thanh toán",
              content:
                  "Tất cả khoản thanh toán cho khóa học hoặc gói đăng ký phải được thực hiện thông qua các phương thức được chấp thuận. Phí sẽ không được hoàn lại trừ khi pháp luật yêu cầu hoặc được quy định cụ thể trong chương trình khuyến mãi.",
            ),

            const LegalDocumentSection(
              title: "5. Quyền sở hữu trí tuệ",
              content:
                  "Tất cả nội dung, bao gồm văn bản, hình ảnh, logo và phần mềm, đều thuộc sở hữu hoặc được cấp phép cho chúng tôi. Bạn không được sao chép, chỉnh sửa hoặc khai thác bất kỳ phần nào của nền tảng khi chưa có sự đồng ý trước.",
            ),

            const LegalDocumentSection(
              title: "6. Hành vi bị cấm",
              content:
                  "Bạn đồng ý không sử dụng sai mục đích nền tảng, bao gồm nhưng không giới hạn ở việc tấn công, khai thác dữ liệu, phát tán phần mềm độc hại hoặc gây gián đoạn trải nghiệm của người dùng khác.",
            ),

            const LegalDocumentSection(
              title: "7. Chấm dứt tài khoản",
              content:
                  "Chúng tôi có quyền tạm ngưng hoặc chấm dứt tài khoản của bạn nếu bạn vi phạm các Điều khoản này hoặc tham gia vào hành vi gian lận, lạm dụng hoặc bất hợp pháp trên nền tảng.",
            ),

            const LegalDocumentSection(
              title: "8. Giới hạn trách nhiệm",
              content:
                  "Chúng tôi không chịu trách nhiệm cho bất kỳ thiệt hại gián tiếp, ngẫu nhiên hoặc hậu quả nào phát sinh từ việc bạn sử dụng nền tảng. Việc sử dụng dịch vụ là rủi ro của riêng bạn.",
            ),

            const LegalDocumentSection(
              title: "9. Thay đổi Điều khoản",
              content:
                  "Chúng tôi có thể cập nhật các Điều khoản và Điều kiện này theo thời gian. Việc tiếp tục sử dụng nền tảng sau khi thay đổi đồng nghĩa với việc bạn chấp nhận các điều khoản mới.",
            ),

            const LegalDocumentSection(
              title: "10. Thông tin liên hệ",
              content:
                  "Nếu bạn có bất kỳ câu hỏi hoặc thắc mắc nào về các Điều khoản và Điều kiện này, vui lòng liên hệ với chúng tôi qua email: support@example.com.",
            ),
          ],
        ),
      ),
    );
  }
}
