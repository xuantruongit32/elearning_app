import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
import 'package:elearning_app/view/teacher/payment/widgets/balance_card.dart';
import 'package:elearning_app/view/teacher/payment/widgets/payment_history_list.dart';
import 'package:elearning_app/view/teacher/payment/widgets/withdrawal_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/withdrawal.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherPaymentsScreen extends StatelessWidget {
  const TeacherPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeacherRepository repository = Get.put(TeacherRepository());

    final String? teacherId = FirebaseAuth.instance.currentUser?.uid;

    if (teacherId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lỗi'),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.accent),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    final Stream<double> balanceStream = repository.getBalanceStream(teacherId);
    final Stream<List<SimplePayment>> paymentStream = repository
        .getPaymentHistoryStream(teacherId);
    final Stream<List<Withdrawal>> withdrawalStream = repository
        .getWithdrawalHistoryStream(teacherId);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Quản lý Thanh toán',
              style: TextStyle(color: AppColors.accent),
            ),
            backgroundColor: AppColors.primary,
            pinned: true,
            iconTheme: const IconThemeData(color: AppColors.accent),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<double>(
                stream: balanceStream,
                builder: (context, snapshot) {
                  final double currentBalance = snapshot.data ?? 0.0;
                  final bool isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (snapshot.hasError)
                        const Text('Lỗi tải số dư')
                      else
                        BalanceCard(balance: currentBalance),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Get.to(
                                    () => WithdrawalScreen(
                                      currentBalance: currentBalance,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Tạo yêu cầu rút tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Lịch sử giao dịch',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 16),

                      PaymentHistoryList(
                        paymentStream: paymentStream,
                        withdrawalStream: withdrawalStream,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
