import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning_app/controllers/course_controller.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/admin/widgets/course_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController controller = Get.put(CourseController());

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
                    hintText: 'Tìm Tên, ID Khóa, ID Giảng viên...',
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
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedCategory.value,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: 'all',
                            child: Text('Tất cả danh mục'),
                          ),
                          ...controller.categories.map(
                            (cat) => DropdownMenuItem(
                              value: cat.id,
                              child: Text(
                                cat.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (val) =>
                            controller.selectedCategory.value = val!,
                      ),
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
                      child: DropdownButton<CourseSortOption>(
                        value: controller.selectedSort.value,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: CourseSortOption.newest,
                            child: Text('Mới nhất'),
                          ),
                          DropdownMenuItem(
                            value: CourseSortOption.oldest,
                            child: Text('Cũ nhất'),
                          ),
                          DropdownMenuItem(
                            value: CourseSortOption.rating,
                            child: Text('Đánh giá cao'),
                          ),
                          DropdownMenuItem(
                            value: CourseSortOption.revenue,
                            child: Text('Doanh thu cao'),
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

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              if (controller.filteredCourses.isEmpty) {
                return const Center(
                  child: Text('Không tìm thấy khóa học nào.'),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowMinHeight: 70,
                    dataRowMaxHeight: 80,
                    columnSpacing: 24,
                    headingRowColor: MaterialStateProperty.all(
                      AppColors.primary.withOpacity(0.05),
                    ),
                    columns: const [
                      DataColumn(label: Text('Khóa học')),
                      DataColumn(label: Text('Giảng viên (ID)')),
                      DataColumn(label: Text('Giá')),
                      DataColumn(label: Text('Danh mục')),
                      DataColumn(label: Text('Đánh giá')),
                      DataColumn(label: Text('Doanh thu')),
                      DataColumn(label: Text('Hành động')),
                    ],
                    rows: controller.filteredCourses.map((course) {
                      return DataRow(
                        cells: [
                          // 1. Khóa học
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: course.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(color: Colors.grey[200]),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          course.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          course.id,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Text(
                                course.instructorId,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              course.price == 0
                                  ? 'Miễn phí'
                                  : controller.formatCurrency(course.price),
                              style: TextStyle(
                                color: course.price == 0
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              controller.categoryMap[course.categoryId] ??
                                  course.categoryId,
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(course.rating.toStringAsFixed(1)),
                                Text(
                                  ' (${course.reviewCount})',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              controller.formatCurrency(
                                course.price * course.enrollmentCount,
                              ),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Xem chi tiết',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CourseDetailDialog(course: course),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Xóa khóa học',
                                  onPressed: () =>
                                      controller.deleteCourse(course.id),
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
          ),
        ),
      ],
    );
  }
}
