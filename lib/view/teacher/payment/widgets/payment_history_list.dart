import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/core/theme/app_colors.dart';

import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentHistoryList extends StatelessWidget {
  final Stream<List<SimplePayment>> paymentStream;
  final Stream<List<Withdrawal>> withdrawalStream;

  const PaymentHistoryList({
    super.key,
    required this.paymentStream,
    required this.withdrawalStream,
  });

  Widget _buildStatusChip(String status) {
    String text;
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        text = 'Đang chờ';
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        break;
      case 'completed':
      case 'success':
        text = 'Thành công';
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;
      case 'cancelled':
      case 'failed':
        text = 'Thất bại';
        chipColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        break;
      default:
        text = status;
        chipColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    final chipWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      child: Row(mainAxisSize: MainAxisSize.min, children: [chipWidget]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    );
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return StreamBuilder<List<SimplePayment>>(
      stream: paymentStream,
      builder: (context, paymentSnapshot) {
        return StreamBuilder<List<Withdrawal>>(
          stream: withdrawalStream,
          builder: (context, withdrawalSnapshot) {
            if (paymentSnapshot.connectionState == ConnectionState.waiting ||
                withdrawalSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (paymentSnapshot.hasError || withdrawalSnapshot.hasError) {
              String error = (paymentSnapshot.error ?? withdrawalSnapshot.error)
                  .toString();
              debugPrint(error);
              return const Center(child: Text('Lỗi tải lịch sử giao dịch.'));
            }

            final payments = paymentSnapshot.data ?? [];
            final withdrawals = withdrawalSnapshot.data ?? [];

            List<dynamic> combinedList = [...payments, ...withdrawals];

            combinedList.sort((a, b) {
              DateTime dateA = (a.date as Timestamp).toDate();
              DateTime dateB = (b.date as Timestamp).toDate();
              return dateB.compareTo(dateA); 
            });

            if (combinedList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text(
                    'Chưa có giao dịch nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: combinedList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = combinedList[index];
                bool isDeposit = item is SimplePayment;

                String title;
                String amountString;
                Color amountColor;
                IconData iconData;
                Widget? subtitle;

                DateTime itemDate = (item.date as Timestamp).toDate();

                if (isDeposit) {
                  final SimplePayment payment = item as SimplePayment;

                  title =
                      'Thanh toán học phí - ${dateFormatter.format(itemDate)}';
                  amountString = '+${currencyFormatter.format(payment.amount)}';
                  amountColor = Colors.green.shade700;
                  iconData = Icons.arrow_downward;

                 
                  subtitle = Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã KH: ${payment.courseId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Học viên: ${payment.studentId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                } else {
                  Withdrawal withdrawal = item as Withdrawal;

                  title =
                      '${withdrawal.bankName} - ${dateFormatter.format(itemDate)}';

                  amountString =
                      '-${currencyFormatter.format(withdrawal.amount)}';
                  amountColor = Colors.red.shade700;
                  iconData = Icons.arrow_upward;
                  subtitle = _buildStatusChip(withdrawal.status);
                }

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: amountColor.withValues(alpha: 0.1),
                      child: Icon(iconData, color: amountColor, size: 20),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: subtitle,
                    trailing: Text(
                      amountString,
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
