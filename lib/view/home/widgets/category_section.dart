import 'package:elearning_app/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:elearning_app/bloc/filtered_course/filtered_course_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/category.dart';
import 'package:elearning_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh mục',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              // SỬA ĐỔI: Gọi hàm mới
              onPressed: () => _showAllCategoriesSheet(context),
              child: Text(
                'Xem tất cả',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) =>
                _buildCategoryCard(context, categories[index]),
          ),
        ),
      ],
    );
  }

  // MỚI: Dùng showModalBottomSheet thay vì showDialog
  void _showAllCategoriesSheet(BuildContext pageContext) {
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true, // Cho phép sheet cao hơn 50% màn hình
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        // DraggableScrollableSheet cho phép sheet co giãn và scroll
        return DraggableScrollableSheet(
          expand: false, // Không full màn hình
          initialChildSize: 0.6, // Chiều cao ban đầu (60% màn hình)
          minChildSize: 0.4, // Chiều cao nhỏ nhất
          maxChildSize: 0.9, // Chiều cao lớn nhất
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                // Thanh "nắm kéo"
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Tất cả danh mục',
                  style: Theme.of(pageContext).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // GridView bọc trong Expanded để nó scroll được
                Expanded(
                  child: GridView.builder(
                    controller: scrollController, // Dùng chung scrollController
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Hiển thị 3 cột
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0, // Ô vuông
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _buildGridCategoryCard(
                        pageContext, // Context của trang (cho Bloc/Theme)
                        sheetContext, // Context của Sheet (để đóng sheet)
                        categories[index],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // MỚI: Card cho GridView (đã tối giản)
  Widget _buildGridCategoryCard(
    BuildContext pageContext,
    BuildContext sheetContext, // Dùng để đóng bottom sheet
    Category category,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // SỬA ĐỔI: Đóng bottom sheet
            Navigator.of(sheetContext).pop(); 
            _handleCategoryTap(pageContext, category);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(pageContext).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Đã bỏ "số khóa học" để tránh overflow
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Giữ nguyên: Card cho ListView
  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleCategoryTap(context, category),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.courseCount} khóa học',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Giữ nguyên: Hàm xử lý tap
  void _handleCategoryTap(context, category) {
    Get.toNamed(
      AppRoutes.courseList,
      arguments: {'category': category.id, 'categoryName': category.name},
      parameters: {'category': category.id, 'categoryName': category.name},
    );
    context.read<FilteredCourseBloc>().add(
          FilterCoursesByCategory(category.id),
        );
  }
}