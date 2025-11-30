import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/controllers/category_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());
    /*  Future<void> seedTransactions() async {
      final firestore = FirebaseFirestore.instance;
      final collectionRef = firestore.collection('payments');

      const String teacherId = "DN7qyLeAPBhd6jX6pHc603QRu9J3";
      const String courseId = "8fd09a5c-e798-4abb-9b95-235afbd4990e";

      final List<String> studentIds = [
        "CT1Q2i98mUZivU3pS6A9tHxtZVl1",
        "XzXYkJBWm5UzUy1IO9R1m0EkGP63",
        "a2Bf32whlOf2k5CwH9eeDSzMhUH3",
        "i3SFZxD3FLVTzQ4OEnnKzJN9kYO2",
        "yIyJTEEOBfUDQeX7vgckFuD43Ha2",
      ];

      WriteBatch batch = firestore.batch();
      final random = Random();

      for (var studentId in studentIds) {
        DocumentReference docRef = collectionRef.doc();

        // Random ngày trong 2 năm (365 * 2 = 730 ngày)
        DateTime now = DateTime.now();
        DateTime randomDate = now.subtract(
          Duration(
            days: random.nextInt(730),
            hours: random.nextInt(24),
            minutes: random.nextInt(60),
          ),
        );

        // Random tiền chẵn (Ví dụ: từ 100k đến 2 triệu, bội số của 50k)
        // (1 -> 40) * 50000 = 50.000 -> 2.000.000
        int randomAmount = (random.nextInt(40) + 1) * 50000;

        // Dữ liệu theo format của bạn
        Map<String, dynamic> data = {
          "amount": randomAmount,
          "courseId": courseId,
          "date": Timestamp.fromDate(randomDate), // Firebase dùng Timestamp
          "studentId": studentId,
          "teacherId": teacherId,
        };

        // Thêm vào batch
        batch.set(docRef, data);
        debugPrint(
          "Đã chuẩn bị data cho Student: $studentId - Tiền: $randomAmount",
        );
      }

      // 4. Thực thi ghi dữ liệu lên Firebase
      try {
        await batch.commit();
        debugPrint("✅ Đã tạo thành công 5 giao dịch!");
      } catch (e) {
        debugPrint("❌ Lỗi khi tạo dữ liệu: $e");
      }
    }
    */

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm danh mục...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Thêm mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => controller.showCategoryDialog(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              if (controller.filteredCategories.isEmpty) {
                return const Center(
                  child: Text('Không tìm thấy danh mục nào.'),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40,
                  columns: [
                    const DataColumn(label: Text('Icon')),
                    const DataColumn(label: Text('Tên Danh mục')),

                    DataColumn(
                      label: Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Số khóa học',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const DataColumn(label: Text('Mã Icon')),
                    const DataColumn(label: Text('Hành động')),
                  ],
                  rows: controller.filteredCategories.map((category) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Icon(
                            controller.getIconData(category.icon),
                            color: AppColors.primary,
                          ),
                        ),
                        DataCell(Text(category.name)),

                        DataCell(
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Obx(
                                () => Text(
                                  controller.courseCounts[category.id]
                                          ?.toString() ??
                                      '...',
                                ),
                              ),
                            ),
                          ),
                        ),

                        DataCell(Text(category.icon)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  controller.showCategoryDialog(
                                    category: category,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.deleteCategory(category.id);
                                },
                              ),
                              /*    ElevatedButton(
                                onPressed: () async {
                                  await seedTransactions();
                                  // Có thể thêm ScaffoldMessenger để hiện thông báo
                                },
                                child: const Text("Tạo dữ liệu test"),
                              ),
                              */
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
