import 'package:elearning_app/controllers/withdrawal_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/admin/widgets/withdrawal_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminWithdrawalScreen extends StatelessWidget {
  const AdminWithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawalController());

    return DefaultTabController(
      length: 2,
      child: Column(
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
                    onChanged: (val) => controller.searchQuery.value = val,
                    decoration: InputDecoration(
                      hintText: 'Tìm TeacherID, Tên TK, Ngân hàng...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.accent.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
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
                        child: DropdownButton<WithdrawalSortOption>(
                          value: controller.selectedSort.value,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: WithdrawalSortOption.newest,
                              child: Text('Mới nhất'),
                            ),
                            DropdownMenuItem(
                              value: WithdrawalSortOption.oldest,
                              child: Text('Cũ nhất'),
                            ),
                            DropdownMenuItem(
                              value: WithdrawalSortOption.amountHigh,
                              child: Text('Số tiền cao'),
                            ),
                            DropdownMenuItem(
                              value: WithdrawalSortOption.amountLow,
                              child: Text('Số tiền thấp'),
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
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: [
                Obx(
                  () =>
                      Tab(text: 'Chờ duyệt (${controller.pendingList.length})'),
                ),
                Obx(
                  () => Tab(text: 'Lịch sử (${controller.historyList.length})'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Expanded(
            child: TabBarView(
              children: [
                WithdrawalPendingTab(), // Widget 1
                WithdrawalHistoryTab(), // Widget 2
              ],
            ),
          ),
        ],
      ),
    );
  }
}
