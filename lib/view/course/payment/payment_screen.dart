import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/payment_service.dart';
import 'package:elearning_app/view/course/payment/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final double price;

  const PaymentScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.price,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Xác nhận thanh toán',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderSummary(courseName: widget.courseName, price: widget.price),
            const SizedBox(height: 32),

            Text(
              'Bạn sẽ được chuyển hướng đến cổng thanh toán VNPAY an toàn để hoàn tất giao dịch.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Image.network(
                'https://vnpay.vn/s1/statics/Images/logo-vnpay-new.png',
                height: 28,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                  );
                },
              ),
              label: const Text(
                'Thanh toán an toàn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => PaymentService.processPayment(
                courseId: widget.courseId,
                amount: widget.price,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
