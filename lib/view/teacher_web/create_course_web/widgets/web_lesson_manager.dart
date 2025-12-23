import 'package:chewie/chewie.dart'; // Thay thế better_player
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';

class WebLessonManager extends StatelessWidget {
  final List<Lesson> lessons;
  final Map<int, bool> isUploadingVideo;
  final Map<int, bool> isUploadingResource;
  final Map<int, ChewieController?> chewieControllers;

  final VoidCallback onAddLesson;
  final Function(int) onRemoveLesson;
  final Function(
    int, {
    String? title,
    String? description,
    String? videoUrl,
    int? duration,
    List<Resource>? resources,
    bool? isPreview,
  })
  onUpdateLesson;
  final Function(int) onPickVideo;
  final Function(int) onAddResource;
  final Function(int, int) onRemoveResource;

  const WebLessonManager({
    super.key,
    required this.lessons,
    required this.isUploadingVideo,
    required this.isUploadingResource,
    required this.chewieControllers,
    required this.onAddLesson,
    required this.onRemoveLesson,
    required this.onUpdateLesson,
    required this.onPickVideo,
    required this.onAddResource,
    required this.onRemoveResource,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nội dung khóa học",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            OutlinedButton.icon(
              onPressed: onAddLesson,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text("Thêm bài học mới  "),
              style:
                  OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(MaterialState.hovered))
                        return AppColors.primary.withOpacity(0.08);
                      return null;
                    }),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (lessons.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Text(
                "Chưa có bài học nào. Hãy thêm bài học đầu tiên!",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lessons.length,
            separatorBuilder: (c, i) => const SizedBox(height: 24),
            itemBuilder: (context, index) =>
                _buildLessonCard(context, lessons[index], index),
          ),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson, int index) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Bài học ${index + 1}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text("Xem trước"),
                    Switch(
                      value: lesson.isPreview,
                      onChanged: (v) => onUpdateLesson(index, isPreview: v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onRemoveLesson(index),
                ),
              ],
            ),
            const Divider(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Tên bài học',
                        hint: 'Nhập tên bài học',
                        initialValue: lesson.title,
                        onChanged: (v) => onUpdateLesson(index, title: v),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Mô tả',
                        hint: 'Nhập mô tả ngắn',
                        maxLines: 3,
                        initialValue: lesson.description,
                        onChanged: (v) => onUpdateLesson(index, description: v),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Thời lượng (phút)',
                        hint: '30',
                        keyboardType: TextInputType.number,
                        initialValue: lesson.duration > 0
                            ? lesson.duration.toString()
                            : '',
                        onChanged: (v) => onUpdateLesson(
                          index,
                          duration: int.tryParse(v ?? '0') ?? 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Video bài giảng",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child:
                            lesson.videoUrl.isNotEmpty &&
                                chewieControllers[index] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Chewie(
                                  controller: chewieControllers[index]!,
                                ), 
                              )
                            : Center(
                                child: isUploadingVideo[index] == true
                                    ? const CircularProgressIndicator()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.video_library_outlined,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton(
                                            onPressed: () => onPickVideo(index),
                                            child: const Text("Tải video lên"),
                                          ),
                                        ],
                                      ),
                              ),
                      ),
                      if (lesson.videoUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton.icon(
                            onPressed: () => onPickVideo(index),
                            icon: const Icon(
                              Icons.change_circle_outlined,
                              size: 16,
                            ),
                            label: const Text("Đổi video khác"),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Tài liệu đính kèm",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ...lesson.resources.asMap().entries.map((entry) {
                    final rIndex = entry.key;
                    final res = entry.value;
                    return ListTile(
                      leading: const Icon(
                        Icons.attach_file,
                        color: AppColors.primary,
                      ),
                      title: Text(res.title),
                      subtitle: Text(res.type.toUpperCase()),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => onRemoveResource(index, rIndex),
                      ),
                    );
                  }),
                  ListTile(
                    leading: isUploadingResource[index] == true
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey,
                          ),
                    title: const Text(
                      "Thêm tài liệu",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: isUploadingResource[index] == true
                        ? null
                        : () => onAddResource(index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
