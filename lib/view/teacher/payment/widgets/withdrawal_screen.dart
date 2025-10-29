import 'package:elearning_app/core/theme/app_colors.dart';
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
  // THÊM CONTROLLERS MỚI
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  String? _selectedBank;

  // Dữ liệu giả cho ngân hàng - ĐÃ CẬP NHẬT
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
    // DISPOSE CONTROLLERS MỚI
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _onWithdrawPressed() {
    if (_formKey.currentState!.validate()) {
      // Ẩn bàn phím
      FocusManager.instance.primaryFocus?.unfocus();
      // Hiển thị dialog
      _showConfirmationDialog();
    }
  }

  // --- HÀM NÀY ĐÃ ĐƯỢC CẬP NHẬT ---
  void _showConfirmationDialog() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final formattedAmount = _currencyFormatter.format(amount);
    // Lấy thông tin tài khoản
    final accountNumber = _accountNumberController.text;
    final accountName = _accountNameController.text;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận rút tiền'),
        // Cập nhật nội dung dialog để hiển thị đầy đủ thông tin
        content: Text(
          'Rút $formattedAmount về tài khoản:\n\n'
          'Ngân hàng: $_selectedBank\n'
          'STK: $accountNumber\n'
          'Chủ TK: $accountName\n\n'
          'Bạn có chắc chắn không?',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Đóng dialog
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
            onPressed: () {
              // 1. Đóng dialog
              Get.back();
              // 2. Quay về trang Quản lý thanh toán
              Get.back();
              // 3. Hiển thị thông báo (snackbar)
              Get.snackbar(
                "Yêu cầu đã được gửi",
                "Tiền của bạn sẽ về tài khoản trong 3-5 ngày làm việc.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(12),
                borderRadius: 8,
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
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
      // --- THÊM WIDGET NÀY ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Chọn ngân hàng
                DropdownButtonFormField<String>(
                  value: _selectedBank,
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

                // --- THÊM MỚI ---
                // 2. Số tài khoản
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

                // 3. Tên chủ tài khoản
                TextFormField(
                  controller: _accountNameController,
                  // Tự động viết hoa chữ cái đầu
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

                // --- KẾT THÚC THÊM MỚI ---
                const SizedBox(height: 24),

                // 4. Nhập số tiền (trước là 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số tiền muốn rút',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                    ),
                    // Nút gợi ý số dư
                    TextButton(
                      onPressed: () {
                        // Sử dụng toStringAsFixed(0) để bỏ phần .00
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
                  // Chỉ cho phép nhập số
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

                // --- THAY ĐỔI SPACER THÀNH SIZEDBOX ---
                const SizedBox(height: 32),

                // --- THÊM DÒNG CẢNH BÁO ---
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
                // --- KẾT THÚC CẢNH BÁO ---

                // 5. Nút rút tiền (trước là 3)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onWithdrawPressed,
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
