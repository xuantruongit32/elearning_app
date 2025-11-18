import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/category_firestore.dart';
import 'package:elearning_app/respositories/category_respository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = Get.put(CategoryRepository());

  var categories = <CategoryFirestoreModel>[].obs;
  var filteredCategories = <CategoryFirestoreModel>[].obs;
  var searchQuery = ''.obs;
  var courseCounts = <String, int>{}.obs;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController iconController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(_repository.getCategoriesforWeb());
    ever(categories, _loadAllCourseCounts);

    ever(categories, (_) => filterCategories());
    ever(searchQuery, (_) => filterCategories());
  }

  void filterCategories() {
    String query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) => category.name.toLowerCase().contains(query))
          .toList();
    }
  }

  void showCategoryDialog({CategoryFirestoreModel? category}) {
    bool isEditing = category != null;
    final theme = Theme.of(Get.context!);

    nameController.text = category?.name ?? '';
    iconController.text = category?.icon.replaceAll('0x', '') ?? '';

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          isEditing ? 'Sửa Danh mục' : 'Thêm Danh mục',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên danh mục',
                  filled: true,
                  fillColor: AppColors.accent.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: iconController,
                decoration: InputDecoration(
                  labelText: 'Mã Icon (ví dụ: e894)',
                  prefixText: '0x ',
                  filled: true,
                  fillColor: AppColors.accent.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã icon';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Hủy', style: TextStyle(color: AppColors.secondary)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(isEditing ? 'Lưu' : 'Thêm'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String iconCode = '0x${iconController.text}';
                if (isEditing) {
                  CategoryFirestoreModel updatedCategory =
                      CategoryFirestoreModel(
                        id: category!.id,
                        name: nameController.text,
                        icon: iconCode,
                      );
                  _repository.updateCategory(updatedCategory);
                } else {
                  CategoryFirestoreModel newCategory = CategoryFirestoreModel(
                    id: '',
                    name: nameController.text,
                    icon: iconCode,
                  );
                  _repository.addCategory(newCategory);
                }
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadAllCourseCounts(List<CategoryFirestoreModel> cats) async {
    final countFutures = cats.map((cat) {
      return _repository.getCourseCount(cat.id);
    }).toList();

    final counts = await Future.wait(countFutures);

    final newCounts = <String, int>{};
    for (int i = 0; i < cats.length; i++) {
      newCounts[cats[i].id] = counts[i];
    }
    courseCounts.value = newCounts;
  }

  void deleteCategory(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
        actions: [
          TextButton(
            child: Text('Hủy', style: TextStyle(color: AppColors.secondary)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
            onPressed: () {
              _repository.deleteCategory(id);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  IconData getIconData(String iconCode) {
    try {
      String cleanHex = iconCode.toLowerCase();

      if (cleanHex.startsWith('0x')) {
        cleanHex = cleanHex.substring(2);
      } else if (cleanHex.startsWith('ox')) {
        cleanHex = cleanHex.substring(2);
      }

      if (cleanHex.isEmpty) return Icons.category;

      return IconData(
        int.parse(cleanHex, radix: 16),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return Icons.error;
    }
  }
}
