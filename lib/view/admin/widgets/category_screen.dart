import 'package:elearning_app/controllers/category_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());

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
