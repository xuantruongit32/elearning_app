import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CourseFilterDialog extends StatefulWidget {
  final Function(String) onLevelSelected;
  final String? initialLevel;
  final Function(bool) onPurchasedToggle;
  final bool initialShowPurchased;

  const CourseFilterDialog({
    super.key,
    required this.onLevelSelected,
    this.initialLevel,
    required this.onPurchasedToggle,
    required this.initialShowPurchased,
  });
   static final Map<String, String> levelDisplayMap = {
    'All': 'Tất cả trình độ',
    'Beginner': 'Cơ bản',
    'Intermediate': 'Trung cấp',
    'Advanced': 'Nâng cao',
  };

  @override
  State<CourseFilterDialog> createState() => _CourseFilterDialogState();
}

class _CourseFilterDialogState extends State<CourseFilterDialog> {
  late String _selectedLevel;
  late bool _isPurchasedSelected;

 

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel ?? 'All';
    _isPurchasedSelected = widget.initialShowPurchased;
  }

  void _handleApplyFilter() {
    widget.onLevelSelected(_selectedLevel);
    widget.onPurchasedToggle(_isPurchasedSelected);
    Navigator.pop(context);
  }

  void _handleResetFilter() {
    setState(() {
      _selectedLevel = 'All';
      _isPurchasedSelected = false;
    });
    widget.onLevelSelected('All');
    widget.onPurchasedToggle(false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...CourseFilterDialog.levelDisplayMap.keys.map(_buildLevelOption),
            const Divider(height: 24),

            _buildPurchasedOption(),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _handleResetFilter,
                    child: const Text('Đặt lại'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleApplyFilter,
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelOption(String level) {
    final isSelected = _selectedLevel == level;
    return ListTile(
      title: Text(CourseFilterDialog.levelDisplayMap[level] ?? level),
      contentPadding: EdgeInsets.zero,
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
    );
  }

  Widget _buildPurchasedOption() {
    return SwitchListTile(
      title: const Text('Chỉ hiển thị khóa học đã ghi danh'),
      value: _isPurchasedSelected,
      onChanged: (newValue) {
        setState(() {
          _isPurchasedSelected = newValue;
        });
      },
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      secondary: Icon(
        Icons.shopping_cart,
        color: _isPurchasedSelected ? AppColors.primary : Colors.grey,
      ),
    );
  }
}
