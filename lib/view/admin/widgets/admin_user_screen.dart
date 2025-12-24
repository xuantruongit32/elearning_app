import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning_app/controllers/user_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/admin/widgets/user_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

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
                // Search
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    decoration: InputDecoration(
                      hintText: 'Tìm Tên, Email, UID...',
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

                // Date Picker
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    final range = controller.dateRange.value;
                    String text = range == null
                        ? 'Ngày tham gia'
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
                            Text(
                              text,
                              style: TextStyle(
                                color: range == null
                                    ? Colors.grey[700]
                                    : Colors.black,
                              ),
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

                // Sort
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
                        child: DropdownButton<UserSortOption>(
                          value: controller.selectedSort.value,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: UserSortOption.newest,
                              child: Text('Mới nhất'),
                            ),
                            DropdownMenuItem(
                              value: UserSortOption.oldest,
                              child: Text('Cũ nhất'),
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

          //TAB BAR
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
                      Tab(text: 'Học viên (${controller.studentList.length})'),
                ),
                Obx(
                  () => Tab(
                    text: 'Giảng viên (${controller.teacherList.length})',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TAB VIEW
          Expanded(
            child: TabBarView(
              children: [
                // Tab Học viên
                _UserListTab(isTeacher: false),
                // Tab Giảng viên
                _UserListTab(isTeacher: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget con để hiển thị danh sách
class _UserListTab extends GetView<UserController> {
  final bool isTeacher;
  const _UserListTab({required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        // Chọn list dựa trên tab
        final users = isTeacher
            ? controller.teacherList
            : controller.studentList;

        if (users.isEmpty) {
          return const Center(child: Text('Không tìm thấy người dùng nào.'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 70,
              columns: const [
                DataColumn(label: Text('Người dùng')),
                DataColumn(label: Text('Liên hệ')),
                DataColumn(label: Text('Ngày tham gia')),
                DataColumn(label: Text('UID')),
                DataColumn(label: Text('Hành động')),
              ],
              rows: users.map((user) {
                // Kiểm tra role để hiển thị badge màu

                final hasPhoto =
                    user.photoUrl != null && user.photoUrl!.isNotEmpty;

                return DataRow(
                  cells: [
                    // Avatar + Tên
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: hasPhoto
                                ? CachedNetworkImageProvider(user.photoUrl!)
                                : null,
                            child: !hasPhoto
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.fullName ?? 'Chưa đặt tên',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isTeacher
                                      ? Colors.orange[100]
                                      : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isTeacher ? 'Giảng viên' : 'Học viên',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isTeacher
                                        ? Colors.orange[800]
                                        : Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Email
                    DataCell(Text(user.email)),
                    // Ngày tạo (createdAt là DateTime sẵn rồi)
                    DataCell(Text(controller.formatDate(user.createdAt))),
                    // UID (Copy được)
                    DataCell(
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: user.uid));
                          
                        },
                        child: Row(
                          children: [
                            Text(
                              user.uid.length > 6
                                  ? '${user.uid.substring(0, 6)}...'
                                  : user.uid,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const Icon(
                              Icons.copy,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Hành động
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                            ),
                            tooltip: 'Xem chi tiết',
                            onPressed: () {
                              Get.dialog(UserDetailDialog(user: user));
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.email_outlined,
                              color: Colors.blue,
                            ),
                            tooltip: 'Gửi mail',
                            onPressed: () =>
                                controller.showEmailDialog(context, user),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            tooltip: 'Xóa người dùng',
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: Text(
                                    'Bạn có chắc chắn muốn xóa người dùng "${user.fullName ?? 'này'}" không?\nHành động này không thể hoàn tác.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Hủy'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                        controller.deleteUser(user);
                                      },
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                ),
                              );
                            },
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
}
