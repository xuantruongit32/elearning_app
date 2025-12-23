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
          'Chính sách quyền riêng tư',
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
              'Cập nhật lần cuối: 15 Tháng 11, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            const LegalDocumentSection(
              title: "1. Thông tin chúng tôi thu thập",
              content:
                  "Chúng tôi thu thập thông tin mà bạn cung cấp trực tiếp, bao gồm nhưng không giới hạn ở họ tên, địa chỉ email, số điện thoại, thông tin thanh toán và bất kỳ dữ liệu nào khác mà bạn chia sẻ khi sử dụng dịch vụ của chúng tôi.",
            ),

            const LegalDocumentSection(
              title: "2. Cách chúng tôi sử dụng thông tin của bạn",
              content:
                  "Chúng tôi sử dụng thông tin của bạn để cung cấp, duy trì và cải thiện dịch vụ, xử lý giao dịch, gửi thông báo hoặc tài liệu khuyến mãi, và mang đến trải nghiệm cá nhân hóa. Chúng tôi cũng có thể sử dụng dữ liệu cho phân tích, nghiên cứu và tăng cường bảo mật.",
            ),

            const LegalDocumentSection(
              title: "3. Bảo mật dữ liệu",
              content:
                  "Chúng tôi áp dụng các biện pháp kỹ thuật và tổ chức phù hợp để bảo vệ dữ liệu của bạn khỏi truy cập trái phép, mất mát, lạm dụng hoặc thay đổi. Tuy nhiên, xin lưu ý rằng không có phương thức truyền dữ liệu nào qua Internet đảm bảo an toàn tuyệt đối 100%.",
            ),

            const LegalDocumentSection(
              title: "4. Quyền của bạn",
              content:
                  "Bạn có quyền truy cập, chỉnh sửa hoặc xóa dữ liệu cá nhân của mình. Bạn cũng có thể rút lại sự đồng ý hoặc phản đối một số hoạt động xử lý dữ liệu, phù hợp với các quy định về bảo vệ dữ liệu hiện hành.",
            ),

            const LegalDocumentSection(
              title: "5. Lưu trữ dữ liệu",
              content:
                  "Chúng tôi chỉ lưu giữ thông tin cá nhân của bạn trong thời gian cần thiết để thực hiện các mục đích được nêu trong chính sách này, tuân thủ nghĩa vụ pháp lý, giải quyết tranh chấp và thực thi các thỏa thuận.",
            ),

            const LegalDocumentSection(
              title: "6. Dịch vụ bên thứ ba",
              content:
                  "Dịch vụ của chúng tôi có thể chứa liên kết hoặc tích hợp với các nền tảng bên thứ ba. Chúng tôi không chịu trách nhiệm về các chính sách quyền riêng tư của các bên này và khuyến khích bạn đọc kỹ chính sách của họ.",
            ),

            const LegalDocumentSection(
              title: "7. Cookie và công nghệ theo dõi",
              content:
                  "Chúng tôi sử dụng cookie và các công nghệ tương tự để cải thiện trải nghiệm người dùng, phân tích lưu lượng truy cập và cung cấp nội dung cá nhân hóa. Bạn có thể quản lý cài đặt cookie trong trình duyệt của mình.",
            ),

            const LegalDocumentSection(
              title: "8. Quyền riêng tư của trẻ em",
              content:
                  "Dịch vụ của chúng tôi không dành cho trẻ em dưới 13 tuổi. Chúng tôi không cố ý thu thập dữ liệu cá nhân từ trẻ vị thành niên. Nếu bạn tin rằng trẻ đã cung cấp thông tin cho chúng tôi, vui lòng liên hệ để được hỗ trợ xóa dữ liệu.",
            ),

            const LegalDocumentSection(
              title: "9. Cập nhật chính sách",
              content:
                  "Chúng tôi có thể cập nhật Chính sách quyền riêng tư này theo thời gian. Phiên bản cập nhật sẽ được đăng trên trang này với ngày 'cập nhật lần cuối' mới. Việc tiếp tục sử dụng dịch vụ đồng nghĩa với việc bạn chấp nhận các thay đổi đó.",
            ),

            const LegalDocumentSection(
              title: "10. Liên hệ với chúng tôi",
              content:
                  "Nếu bạn có bất kỳ câu hỏi, thắc mắc hoặc yêu cầu nào liên quan đến Chính sách quyền riêng tư này hoặc cách chúng tôi xử lý dữ liệu, vui lòng liên hệ với chúng tôi qua email: privacy@example.com.",
            ),
          ],
        ),
      ),
    );
  }
}
