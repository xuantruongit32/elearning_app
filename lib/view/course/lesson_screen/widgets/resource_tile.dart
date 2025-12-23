import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/services/file_download_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourceTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final String url;
  final String type;
  const ResourceTile({
    super.key,
    required this.title,
    required this.icon,
    required this.url,
    required this.type,
  });

  @override
  State<ResourceTile> createState() => _ResourceTileState();
}

class _ResourceTileState extends State<ResourceTile> {
  bool _isDownloading = false;
  final _fileDownloadService = FileDownloadService();

  Future<void> _handleDownload() async {
    if (_isDownloading) return;

    setState(() => _isDownloading = true);

    try {
      final filename = '${widget.title}.${widget.type}';
      final filePath = await _fileDownloadService.downloadFile(
        widget.url,
        filename,
      );

      // Hiển thị thông báo tải thành công
      Get.snackbar(
        'Thành công',
        'Tệp đã được tải xuống thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Mở tệp sau khi tải xuống
      await _fileDownloadService.openFile(filePath);
    } catch (e) {
      // Hiển thị thông báo lỗi
      Get.snackbar(
        'Lỗi',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleDownload,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (_isDownloading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.download,
                    color: AppColors.secondary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
