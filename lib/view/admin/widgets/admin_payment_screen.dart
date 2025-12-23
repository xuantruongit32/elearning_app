import 'package:elearning_app/controllers/payment_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/admin/widgets/payment_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminPaymentScreen extends StatelessWidget {
  const AdminPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Tìm theo teacherID, studentID, mã GD...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.accent.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                flex: 1,
                child: Obx(() {
                  final range = controller.dateRange.value;
                  String text = range == null
                      ? 'Toàn bộ thời gian'
                      : '${DateFormat('dd/MM').format(range.start)} - ${DateFormat('dd/MM').format(range.end)}';

                  return InkWell(
                    onTap: () => controller.pickDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(text, overflow: TextOverflow.ellipsis),
                          ),
                          if (range != null)
                            InkWell(
                              onTap: controller.clearDateFilter,
                              child: const Icon(Icons.close, size: 18),
                            )
                          else
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 16),

              Expanded(
                flex: 1,
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PaymentSortOption>(
                        value: controller.selectedSort.value,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: PaymentSortOption.newest,
                            child: Text('Mới nhất'),
                          ),
                          DropdownMenuItem(
                            value: PaymentSortOption.oldest,
                            child: Text('Cũ nhất'),
                          ),
                          DropdownMenuItem(
                            value: PaymentSortOption.amountHigh,
                            child: Text('Giá trị cao'),
                          ),
                          DropdownMenuItem(
                            value: PaymentSortOption.amountLow,
                            child: Text('Giá trị thấp'),
                          ),
                        ],
                        onChanged: (val) =>
                            controller.selectedSort.value = val!,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Obx(
          () => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm thấy: ${controller.filteredPayments.length} giao dịch',
                  style: TextStyle(color: Colors.blue.shade900),
                ),
                Text(
                  'Tổng doanh thu: ${controller.formatCurrency(controller.totalRevenue)}',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              if (controller.filteredPayments.isEmpty) {
                return const Center(
                  child: Text('Không tìm thấy giao dịch nào.'),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 70,
                    columnSpacing: 30,
                    headingRowColor: MaterialStateProperty.all(
                      AppColors.primary.withOpacity(0.05),
                    ),
                    columns: const [
                      DataColumn(label: Text('Thời gian')),
                      DataColumn(label: Text('Số tiền')),
                      DataColumn(label: Text('Teacher ID')),
                      DataColumn(label: Text('Student ID')),
                      DataColumn(label: Text('Course ID')),
                      DataColumn(label: Text('Mã GD')),
                      DataColumn(label: Text('Hành động')),
                    ],
                    rows: controller.filteredPayments.map((payment) {
                      DateTime date = payment.date.toDate();
                      return DataRow(
                        cells: [
                          DataCell(Text(controller.formatDate(date))),
                          DataCell(
                            Text(
                              controller.formatCurrency(payment.amount),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildIdCell(payment.teacherId),
                          _buildIdCell(payment.studentId),
                          _buildIdCell(payment.courseId),
                          _buildIdCell(payment.id, isRef: true),

                          // [CẬP NHẬT] Nút Xem chi tiết
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.blue,
                              ),
                              tooltip: 'Xem chi tiết giao dịch',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      PaymentDetailDialog(payment: payment),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  DataCell _buildIdCell(String id, {bool isRef = false}) {
    return DataCell(
      InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: id));
          Get.rawSnackbar(
            message: 'Đã copy: $id',
            duration: const Duration(seconds: 1),
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  id,
                  style: TextStyle(
                    fontSize: 12,
                    color: isRef ? Colors.grey : Colors.black87,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.copy, size: 12, color: Colors.grey.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
