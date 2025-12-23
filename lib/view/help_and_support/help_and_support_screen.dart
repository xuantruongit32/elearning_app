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
          'Trợ giúp & Hỗ trợ',
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
                title: 'Câu hỏi thường gặp',
                children: [
                  FaqTile(
                    questions: 'Làm thế nào để đặt lại mật khẩu?',
                    answer:
                        'Vào màn hình đăng nhập và nhấn vào “Quên mật khẩu”. Làm theo hướng dẫn được gửi đến email của bạn.',
                  ),

                  FaqTile(
                    questions: 'Làm sao để tải khóa học về xem offline?',
                    answer:
                        'Mở khóa học và nhấn vào biểu tượng tải xuống. Hãy đảm bảo thiết bị có đủ dung lượng lưu trữ.',
                  ),

                  FaqTile(
                    questions: 'Tôi có thể được hoàn tiền không?',
                    answer:
                        'Có, trong vòng 30 ngày kể từ ngày mua nếu bạn không hài lòng với khóa học. Vui lòng liên hệ đội ngũ hỗ trợ để được giúp đỡ.',
                  ),

                  FaqTile(
                    questions: 'Có khóa học miễn phí không?',
                    answer:
                        'Có! Chúng tôi cung cấp một số khóa học miễn phí mà bạn có thể học mà không cần thanh toán hay đăng ký.',
                  ),

                  FaqTile(
                    questions: 'Tôi có thể học trên nhiều thiết bị không?',
                    answer:
                        'Có, bạn có thể đăng nhập cùng một tài khoản trên nhiều thiết bị, bao gồm cả điện thoại và máy tính.',
                  ),

                  FaqTile(
                    questions: 'Tiến trình học có được đồng bộ giữa các thiết bị không?',
                    answer:
                        'Tất nhiên! Tiến trình học, ghi chú và kết quả bài kiểm tra của bạn sẽ được đồng bộ tự động trên tất cả các thiết bị.',
                  ),

                  FaqTile(
                    questions: 'Khóa học có cấp chứng chỉ không?',
                    answer:
                        'Có, sau khi hoàn thành khóa học, bạn sẽ nhận được chứng chỉ kỹ thuật số có thể tải về hoặc chia sẻ.',
                  ),

                  FaqTile(
                    questions: 'Làm sao để liên hệ với bộ phận hỗ trợ?',
                    answer:
                        'Bạn có thể liên hệ với đội ngũ hỗ trợ qua mục “Trợ giúp & Hỗ trợ” trong ứng dụng hoặc gửi email đến support@example.com.',
                  ),

                  FaqTile(
                    questions: 'Giảng viên có thể cập nhật nội dung khóa học không?',
                    answer:
                        'Có, giảng viên có thể cập nhật hoặc thêm bài học mới bất cứ lúc nào. Bạn sẽ tự động nhận được các nội dung cập nhật này.',
                  ),

                  FaqTile(
                    questions: 'Khóa học có hết hạn sau khi mua không?',
                    answer:
                        'Không, sau khi mua, bạn sẽ có quyền truy cập trọn đời trừ khi có ghi chú khác trên trang khóa học.',
                  ),

                  FaqTile(
                    questions: 'Tôi có thể chia sẻ tài khoản với người khác không?',
                    answer:
                        'Không, việc chia sẻ tài khoản vi phạm Điều khoản dịch vụ. Mỗi tài khoản chỉ dành cho một người sử dụng.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              HelpSection(
                title: 'Liên hệ với chúng tôi',
                children: [
                  ContactTile(
                    title: 'Hỗ trợ qua Email',
                    subtitle: 'Nhận hỗ trợ qua email',
                    icon: Icons.email_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Trò chuyện trực tiếp',
                    subtitle: 'Trao đổi với đội ngũ hỗ trợ',
                    icon: Icons.chat_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Gọi cho chúng tôi',
                    subtitle: 'Nói chuyện với nhân viên hỗ trợ',
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
