import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để dùng Clipboard
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CourseDetailDialog extends StatelessWidget {
  final Course course;

  const CourseDetailDialog({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Format tiền tệ và ngày tháng
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Tạo chuỗi JSON đẹp (Pretty Print)
    final String prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(course.toJson());

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24), // Cách lề màn hình
      child: Container(
        width: 800, // Độ rộng dialog trên web
        height: MediaQuery.of(context).size.height * 0.9, // Chiếm 90% chiều cao
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER: Title + Close Button ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Chi tiết khóa học',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),

            // === BODY: Scrollable Content ===
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. INFO HEADER (Ảnh + Thông tin cơ bản)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh bìa
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: course.imageUrl,
                            width: 200,
                            height: 120,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Thông tin text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                // Cho phép bôi đen copy text
                                course.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow('ID:', course.id, canCopy: true),
                              _buildInfoRow(
                                'Giảng viên ID:',
                                course.instructorId,
                                canCopy: true,
                              ),
                              _buildInfoRow('Danh mục ID:', course.categoryId),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildChip(
                                    course.isPremium ? 'Trả phí' : 'Miễn phí',
                                    course.isPremium
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildChip(course.level, Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    currencyFormat.format(course.price),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. STATS (Thống kê)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            Icons.people,
                            'Học viên',
                            '${course.enrollmentCount}',
                          ),
                          _buildStatItem(
                            Icons.star,
                            'Đánh giá',
                            '${course.rating.toStringAsFixed(1)} (${course.reviewCount})',
                          ),
                          _buildStatItem(
                            Icons.calendar_today,
                            'Ngày tạo',
                            dateFormat.format(course.createdAt),
                          ),
                          _buildStatItem(
                            Icons.update,
                            'Cập nhật',
                            dateFormat.format(course.updatedAt),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. DESCRIPTION & LISTS
                    _buildSectionTitle('Mô tả'),
                    Text(course.description),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildListSection(
                            'Yêu cầu (Requirements)',
                            course.requirements,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildListSection(
                            'Bạn sẽ học được gì',
                            course.whatYouWillLearn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 4. LESSONS (Danh sách bài học)
                    _buildSectionTitle(
                      'Danh sách bài học (${course.lessons.length})',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: course.lessons.map((lesson) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.accent,
                              child: const Icon(
                                Icons.play_arrow,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              lesson.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text('ID: ${lesson.id}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (lesson.isPreview)
                                  const Chip(
                                    label: Text(
                                      'Preview',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                const SizedBox(width: 8),
                                Text('${lesson.duration} phút'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. RAW JSON DATA (Copy được)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Dữ liệu JSON (Raw)'),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy JSON'),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: prettyJson));
                            Get.snackbar(
                              'Thành công',
                              'Đã copy JSON vào bộ nhớ tạm!',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SelectableText(
                        prettyJson,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          if (canCopy)
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                Get.rawSnackbar(
                  message: 'Đã copy: $value',
                  duration: const Duration(seconds: 1),
                );
              },
              child: const Icon(Icons.copy, size: 14, color: Colors.blueGrey),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text(
            'Không có thông tin',
            style: TextStyle(color: Colors.grey),
          ),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
