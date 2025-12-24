import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/controllers/withdrawal_controller.dart';
import 'package:elearning_app/models/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawalPendingTab extends GetView<WithdrawalController> {
  const WithdrawalPendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        if (controller.pendingList.isEmpty) {
          return const Center(child: Text('Không có yêu cầu nào đang chờ.'));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Ngày tạo')),
                DataColumn(label: Text('Giáo viên (ID)')),
                DataColumn(label: Text('Số tiền')),
                DataColumn(label: Text('Thông tin NH')),
                DataColumn(label: Text('Hành động')),
              ],
              rows: controller.pendingList.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(controller.formatDate(item.date as Timestamp)),
                    ),
                    _buildIdCell(item.teacherId),
                    DataCell(
                      Text(
                        controller.formatCurrency(item.amount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.bankName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${item.accountNumber} - ${item.accountName}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          // Nút Duyệt
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            tooltip: 'Duyệt',
                            onPressed: () => _confirmAction(
                              context,
                              'Duyệt',
                              item,
                              () => controller.approve(item),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Từ chối & Hoàn tiền',
                            onPressed: () => _confirmAction(
                              context,
                              'Từ chối',
                              item,
                              () => controller.reject(item),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  void _confirmAction(
    BuildContext context,
    String action,
    Withdrawal item,
    VoidCallback onConfirm,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('$action yêu cầu rút tiền'),
        content: Text(
          'Bạn có chắc chắn muốn $action yêu cầu ${controller.formatCurrency(item.amount)} không?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(' Xác nhận '),
          ),
        ],
      ),
    );
  }
}

class WithdrawalHistoryTab extends GetView<WithdrawalController> {
  const WithdrawalHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        if (controller.historyList.isEmpty) {
          return const Center(child: Text('Chưa có lịch sử giao dịch.'));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Ngày xử lý')), // Hoặc ngày tạo
                DataColumn(label: Text('Giáo viên ID')),
                DataColumn(label: Text('Số tiền')),
                DataColumn(label: Text('Ngân hàng')),
                DataColumn(label: Text('Trạng thái')),
              ],
              rows: controller.historyList.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(controller.formatDate(item.date as Timestamp)),
                    ),
                    _buildIdCell(item.teacherId),
                    DataCell(
                      Text(
                        controller.formatCurrency(item.amount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text('${item.bankName}\n${item.accountNumber}')),
                    DataCell(_buildStatusChip(item.status)),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        color = Colors.green;
        text = 'Thành công';
        break;
      case 'rejected':
      case 'failed':
        color = Colors.red;
        text = 'Đã từ chối';
        break;
      default:
        color = Colors.grey;
        text = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

DataCell _buildIdCell(String id) {
  return DataCell(
    InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: id));
        
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            id.length > 6 ? '${id.substring(0, 6)}...' : id,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.copy, size: 12, color: Colors.grey),
        ],
      ),
    ),
  );
}
