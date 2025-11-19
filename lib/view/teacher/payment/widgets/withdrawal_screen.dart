import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/respositories/teacher_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WithdrawalScreen extends StatefulWidget {
  final double currentBalance;

  const WithdrawalScreen({super.key, required this.currentBalance});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
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

  final _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmWithdrawal() async {
    if (teacherId == null) {
      Get.snackbar(
        'Lỗi người dùng',
        'Không thể xác định người dùng. Vui lòng đăng nhập lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.tryParse(_amountController.text) ?? 0;
      final accountName = _accountNameController.text.toUpperCase();

      await _repository.createWithdrawal(
        teacherId: teacherId!,
        amount: amount,
        bankName: _selectedBank!,
        accountNumber: _accountNumberController.text,
        accountName: accountName,
      );

      Get.back();
      Get.back();
      Get.snackbar(
        "Yêu cầu đã được gửi",
        "Tiền của bạn sẽ về tài khoản trong 3-5 ngày làm việc.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Gửi yêu cầu thất bại',
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onWithdrawPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final formattedAmount = _currencyFormatter.format(amount);
    final accountNumber = _accountNumberController.text;
    final accountName = _accountNameController.text;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận rút tiền'),
        content: Text(
          'Rút $formattedAmount về tài khoản:\n\n'
          'Ngân hàng: $_selectedBank\n'
          'STK: $accountNumber\n'
          'Chủ TK: ${accountName.toUpperCase()}\n\n'
          'Bạn có chắc chắn không?',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _handleConfirmWithdrawal,
            child: const Text(' Xác nhận '),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Tạo yêu cầu rút tiền',
          style: TextStyle(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedBank,
                  hint: const Text('Chọn ngân hàng nhận tiền'),
                  items: _banks
                      .map(
                        (bank) =>
                            DropdownMenuItem(value: bank, child: Text(bank)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBank = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Vui lòng chọn ngân hàng' : null,
                  decoration: InputDecoration(
                    labelText: 'Ngân hàng',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Số tài khoản',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.accent,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tài khoản';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _accountNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Tên chủ tài khoản',
                    hintText: 'VD: NGUYEN VAN A',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.accent,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên chủ tài khoản';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số tiền muốn rút',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _amountController.text = widget.currentBalance
                            .toStringAsFixed(0);
                      },
                      child: const Text(
                        'Dùng số dư tối đa',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền',
                    prefixText: '₫ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.accent,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Số tiền không hợp lệ';
                    }
                    if (amount > widget.currentBalance) {
                      return 'Số dư không đủ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Vui lòng kiểm tra đầy đủ thông tin trước khi thanh toán. Yêu cầu rút tiền sẽ không thể hoàn tác.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onWithdrawPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Rút tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
