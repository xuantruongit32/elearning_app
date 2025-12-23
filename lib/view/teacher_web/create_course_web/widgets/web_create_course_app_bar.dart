import 'package:flutter/material.dart';

class WebCreateCourseAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isEditMode;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onBack;

  const WebCreateCourseAppBar({
    super.key,
    required this.isEditMode,
    required this.isLoading,
    required this.onSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          bottom: BorderSide(
            color: Colors.white12,
            width: 1,
          ), 
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: kToolbarHeight + 16, 
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: 'Quay lại',
          ),
          const SizedBox(width: 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? 'Chỉnh sửa khóa học' : 'Tạo khóa học mới',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditMode)
                const Text(
                  'Chỉnh sửa nội dung và cấu hình khóa học',
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 12,
                  ),
                ),
            ],
          ),

          const Spacer(),

          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.close, size: 18),
            label: const Text("Hủy bỏ"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              side: const BorderSide(color: Colors.white24),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),

          ElevatedButton.icon(
            onPressed: isLoading ? null : onSave,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.save, size: 18),
            label: Text(isEditMode ? "Cập nhật" : "Tạo khóa học"),
            style: ElevatedButton.styleFrom(
          
              backgroundColor: Colors.white,
              foregroundColor: Colors.black, 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              elevation: 0,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
