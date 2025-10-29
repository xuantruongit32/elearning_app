import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/teacher/payment/widgets/balance_card.dart';
import 'package:elearning_app/view/teacher/payment/widgets/payment_history_list.dart';
import 'package:elearning_app/view/teacher/payment/widgets/withdrawal_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherPaymentsScreen extends StatelessWidget {
  const TeacherPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BalanceCard(balance: 12500000),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(
                          () => WithdrawalScreen(currentBalance: 12500000),
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

                  const PaymentHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
