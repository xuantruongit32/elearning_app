import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WebCourseInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String? imageUrl;
  final bool isUploadingImage;
  final VoidCallback onPickImage;

  const WebCourseInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    this.imageUrl,
    required this.isUploadingImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thông tin cơ bản",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Image Picker Area
            Center(
              child: GestureDetector(
                onTap: onPickImage,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    image: imageUrl != null && !isUploadingImage
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: isUploadingImage
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        )
                      : imageUrl == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Nhấn để tải ảnh bìa (1920x1080)",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Thay đổi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            CustomTextField(
              controller: titleController,
              label: 'Tiêu đề khóa học',
              hint: 'Nhập tiêu đề hấp dẫn',
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Vui lòng nhập tiêu đề' : null,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: descriptionController,
              label: 'Mô tả chi tiết',
              hint: 'Mô tả nội dung khóa học...',
              maxLines: 5,
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Vui lòng nhập mô tả' : null,
            ),
          ],
        ),
      ),
    );
  }
}
