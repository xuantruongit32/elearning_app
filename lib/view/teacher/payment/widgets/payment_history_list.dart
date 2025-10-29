import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentHistoryList extends StatelessWidget {
  const PaymentHistoryList({super.key});

  static final List<String> _dummyData = [
    "28/10/2025: +500.000 ₫",
    "26/10/2025: +250.000 ₫",
    "24/10/2025: +500.000 ₫",
    "23/10/2025: +300.000 ₫",
    "21/10/2025: +150.000 ₫",
    "20/10/2025: +250.000 ₫",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _dummyData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final recordString = _dummyData[index];

        final separatorIndex = recordString.indexOf(': ');
        String datePart = recordString;
        String amountPart = '';

        if (separatorIndex != -1) {
          datePart = recordString.substring(0, separatorIndex);
          amountPart = recordString.substring(separatorIndex + 2);
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
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.receipt_long, color: AppColors.primary),
            ),
            title: Text(
              datePart,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            trailing: Text(
              amountPart,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        );
      },
    );
  }
}
