import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/withdrawal.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//BỘ LỌC NGÀY

class PaymentFilterController extends GetxController {
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();

  Future<void> pickDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: selectedDateRange.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDateRange.value = DateTimeRange(
        start: DateTime(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        ),
        end: DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        ),
      );
    }
  }

  void clearFilter() {
    selectedDateRange.value = null;
  }

  bool isWithinRange(DateTime date) {
    if (selectedDateRange.value == null) return true;
    return date.isAfter(
          selectedDateRange.value!.start.subtract(const Duration(seconds: 1)),
        ) &&
        date.isBefore(
          selectedDateRange.value!.end.add(const Duration(seconds: 1)),
        );
  }

  String get filterText {
    if (selectedDateRange.value == null) return '';
    final start = DateFormat(
      'dd/MM/yyyy',
    ).format(selectedDateRange.value!.start);
    final end = DateFormat('dd/MM/yyyy').format(selectedDateRange.value!.end);
    return '$start - $end';
  }
}

class TeacherPaymentWebScreen extends StatelessWidget {
  const TeacherPaymentWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeacherRepository repository = Get.put(TeacherRepository());
    final PaymentFilterController filterController = Get.put(
      PaymentFilterController(),
    );

    final String? teacherId = FirebaseAuth.instance.currentUser?.uid;

    if (teacherId == null) {
      return const Center(child: Text("Vui lòng đăng nhập để xem thông tin"));
    }

    final Stream<double> balanceStream = repository.getBalanceStream(teacherId);
    final Stream<List<SimplePayment>> paymentStream = repository
        .getPaymentHistoryStream(teacherId);
    final Stream<List<Withdrawal>> withdrawalStream = repository
        .getWithdrawalHistoryStream(teacherId);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.accent),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 900;
          final double contentPadding = isWideScreen ? 32.0 : 16.0;

          return Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isWideScreen ? 350 : 300,
                  child: Column(
                    children: [
                      StreamBuilder<double>(
                        stream: balanceStream,
                        builder: (context, snapshot) {
                          return _WebBalanceCard(
                            balance: snapshot.data ?? 0.0,
                            isLoading:
                                snapshot.connectionState ==
                                ConnectionState.waiting,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildWithdrawButton(context, balanceStream),
                    ],
                  ),
                ),

                const SizedBox(width: 32),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Lịch sử giao dịch',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                              const Spacer(),
                              Obx(() {
                                final hasFilter =
                                    filterController.selectedDateRange.value !=
                                    null;
                                return Row(
                                  children: [
                                    if (hasFilter)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              filterController.filterText,
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            InkWell(
                                              onTap:
                                                  filterController.clearFilter,
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    OutlinedButton.icon(
                                      onPressed: () => filterController
                                          .pickDateRange(context),
                                      icon: const Icon(
                                        Icons.date_range,
                                        size: 18,
                                      ),
                                      label: Text(
                                        hasFilter
                                            ? 'Đổi ngày'
                                            : 'Lọc theo ngày',
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(
                                          color: AppColors.primary,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: _WebPaymentHistoryList(
                            paymentStream: paymentStream,
                            withdrawalStream: withdrawalStream,
                            filterController: filterController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWithdrawButton(
    BuildContext context,
    Stream<double> balanceStream,
  ) {
    return StreamBuilder<double>(
      stream: balanceStream,
      builder: (context, snapshot) {
        final balance = snapshot.data ?? 0.0;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed:
                (snapshot.connectionState == ConnectionState.waiting ||
                    balance <= 0)
                ? null
                : () => showDialog(
                    context: context,
                    builder: (_) =>
                        WebWithdrawalDialog(currentBalance: balance),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.accent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.monetization_on_outlined),
            label: const Text(
              'Tạo yêu cầu rút tiền',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

//WEB PAYMENT HISTORY LIST

class _WebPaymentHistoryList extends StatefulWidget {
  final Stream<List<SimplePayment>> paymentStream;
  final Stream<List<Withdrawal>> withdrawalStream;
  final PaymentFilterController filterController;

  const _WebPaymentHistoryList({
    required this.paymentStream,
    required this.withdrawalStream,
    required this.filterController,
  });

  @override
  State<_WebPaymentHistoryList> createState() => _WebPaymentHistoryListState();
}

class _WebPaymentHistoryListState extends State<_WebPaymentHistoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    );
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return StreamBuilder<List<SimplePayment>>(
      stream: widget.paymentStream,
      builder: (context, paymentSnapshot) {
        return StreamBuilder<List<Withdrawal>>(
          stream: widget.withdrawalStream,
          builder: (context, withdrawalSnapshot) {
            if (!paymentSnapshot.hasData && !withdrawalSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final payments = paymentSnapshot.data ?? [];
            final withdrawals = withdrawalSnapshot.data ?? [];
            List<dynamic> allItems = [...payments, ...withdrawals];

            allItems.sort((a, b) {
              DateTime dateA = (a.date as Timestamp).toDate();
              DateTime dateB = (b.date as Timestamp).toDate();
              return dateB.compareTo(dateA);
            });

            return Obx(() {
              final filteredList = allItems.where((item) {
                final DateTime itemDate = (item.date as Timestamp).toDate();
                return widget.filterController.isWithinRange(itemDate);
              }).toList();

              if (filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.filterController.selectedDateRange.value != null
                            ? 'Không tìm thấy giao dịch trong khoảng thời gian này'
                            : 'Chưa có giao dịch nào',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: filteredList.length,
                  separatorBuilder: (ctx, i) =>
                      const Divider(height: 1, indent: 70, endIndent: 24),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    bool isDeposit = item is SimplePayment;
                    DateTime itemDate = (item.date as Timestamp).toDate();

                    return HoverListTile(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: isDeposit
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: Icon(
                            isDeposit
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isDeposit
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isDeposit
                                    ? 'Thanh toán học phí'
                                    : '${(item as Withdrawal).bankName} - Rút tiền',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (!isDeposit)
                              _buildStatusChip((item as Withdrawal).status),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            dateFormatter.format(itemDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        trailing: Text(
                          '${isDeposit ? '+' : '-'}${currencyFormatter.format(isDeposit ? (item as SimplePayment).amount : (item as Withdrawal).amount)}',
                          style: TextStyle(
                            color: isDeposit
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            });
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        text = "Đang chờ";
        break;
      case 'success':
      case 'completed':
        color = Colors.green;
        text = "Thành công";
        break;
      default:
        color = Colors.red;
        text = "Thất bại";
    }
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WebBalanceCard extends StatelessWidget {
  final double balance;
  final bool isLoading;
  const _WebBalanceCard({required this.balance, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF3E4A61)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số dư khả dụng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : SelectableText(
                  currencyFormatter.format(balance),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'RobotoMono',
                  ),
                ),
        ],
      ),
    );
  }
}

class WebWithdrawalDialog extends StatefulWidget {
  final double currentBalance;
  const WebWithdrawalDialog({super.key, required this.currentBalance});
  @override
  State<WebWithdrawalDialog> createState() => _WebWithdrawalDialogState();
}

class _WebWithdrawalDialogState extends State<WebWithdrawalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  String? _selectedBank;
  bool _isLoading = false;
  final TeacherRepository _repository = Get.find<TeacherRepository>();
  final String? teacherId = FirebaseAuth.instance.currentUser?.uid;
  final List<String> _banks = [
    'Vietcombank',
    'Techcombank',
    'ACB',
    'MB Bank',
    'BIDV',
    'Agribank',
    'VPBank',
    'VietinBank',
    'Sacombank',
    'TPBank',
    'MSB',
    'SHB',
  ];

  Future<void> _handleConfirmWithdrawal() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final amount = double.tryParse(_amountController.text) ?? 0;
      await _repository.createWithdrawal(
        teacherId: teacherId!,
        amount: amount,
        bankName: _selectedBank!,
        accountNumber: _accountNumberController.text,
        accountName: _accountNameController.text.toUpperCase(),
      );
      if (mounted) {
        Navigator.of(context).pop();
        Get.snackbar(
          "Thành công",
          "Yêu cầu rút tiền đã được gửi.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          maxWidth: 400,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Lỗi",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        maxWidth: 400,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yêu cầu rút tiền',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                hint: const Text('Chọn ngân hàng'),
                items: _banks
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedBank = val),
                validator: (v) => v == null ? 'Vui lòng chọn ngân hàng' : null,
                decoration: _inputDecoration('Ngân hàng'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _accountNumberController,
                      decoration: _inputDecoration('Số tài khoản'),
                      validator: (v) => v!.isEmpty ? 'Nhập số TK' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _accountNameController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _inputDecoration('Tên chủ thẻ'),
                      validator: (v) => v!.isEmpty ? 'Nhập tên chủ thẻ' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: _inputDecoration('Số tiền (VNĐ)').copyWith(
                  suffixIcon: TextButton(
                    onPressed: () => _amountController.text = widget
                        .currentBalance
                        .toStringAsFixed(0),
                    child: const Text('Tối đa'),
                  ),
                ),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) return 'Số tiền sai';
                  if (amount > widget.currentBalance) return 'Không đủ số dư';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate())
                            _handleConfirmWithdrawal();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.accent,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Xác nhận rút tiền',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

class HoverListTile extends StatefulWidget {
  final Widget child;
  const HoverListTile({super.key, required this.child});
  @override
  State<HoverListTile> createState() => _HoverListTileState();
}

class _HoverListTileState extends State<HoverListTile> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _isHovering = true),
    onExit: (_) => setState(() => _isHovering = false),
    child: Container(
      decoration: BoxDecoration(
        color: _isHovering ? Colors.grey.shade50 : Colors.transparent,
      ),
      child: widget.child,
    ),
  );
}
