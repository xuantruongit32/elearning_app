import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/prerequisite_course.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';

class WebCourseSettingsSidebar extends StatelessWidget {
  final TextEditingController priceController;
  final String selectedLevel;
  final String? selectedCategoryId;
  final bool isPremium;
  final List<Map<String, dynamic>> categories;
  final List<PrerequisiteCourse> availableCourses;
  final List<String> selectedPrerequisites;
  final List<String> requirements;
  final List<String> learningPoints;

  final Function(String?) onLevelChanged;
  final Function(String?) onCategoryChanged;
  final Function(bool) onPremiumChanged;
  final Function(String?) onPrerequisiteChanged;
  final Function(String) onRemovePrerequisite;
  final VoidCallback onRequirementsChanged;
  final VoidCallback onLearningPointsChanged;

  const WebCourseSettingsSidebar({
    super.key,
    required this.priceController,
    required this.selectedLevel,
    required this.selectedCategoryId,
    required this.isPremium,
    required this.categories,
    required this.availableCourses,
    required this.selectedPrerequisites,
    required this.requirements,
    required this.learningPoints,
    required this.onLevelChanged,
    required this.onCategoryChanged,
    required this.onPremiumChanged,
    required this.onPrerequisiteChanged,
    required this.onRemovePrerequisite,
    required this.onRequirementsChanged,
    required this.onLearningPointsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          title: "Cài đặt khóa học",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: priceController,
                label: 'Giá (VND)',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel("Trình độ"),
              DropdownButtonFormField<String>(
                value: selectedLevel,
                isExpanded: true,
                decoration: _inputDecoration(),
                items: const [
                  DropdownMenuItem(value: 'Beginner', child: Text('Cơ bản')),
                  DropdownMenuItem(
                    value: 'Intermediate',
                    child: Text('Trung bình'),
                  ),
                  DropdownMenuItem(value: 'Advanced', child: Text('Nâng cao')),
                ],
                onChanged: onLevelChanged,
              ),
              const SizedBox(height: 16),
              _buildLabel("Danh mục"),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                isExpanded: true,
                decoration: _inputDecoration(),
                hint: const Text("Chọn danh mục"),
                items: categories
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c['id'],
                        child: Row(
                          children: [
                            Icon(
                              IconData(
                                int.parse(c['icon']),
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(c['name'], overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChanged,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Khóa học Premium",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: isPremium,
                activeColor: AppColors.primary,
                onChanged: onPremiumChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildCard(
          title: "Tiên quyết",
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _inputDecoration(),
                hint: const Text("Thêm khóa học tiên quyết"),
                items: availableCourses
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.title, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: onPrerequisiteChanged,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedPrerequisites.map((id) {
                  final title = availableCourses
                      .firstWhere(
                        (e) => e.id == id,
                        orElse: () =>
                            PrerequisiteCourse(id: id, title: 'Unknown'),
                      )
                      .title;
                  return Chip(
                    label: Text(title, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => onRemovePrerequisite(id),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildCard(
          title: "Chi tiết bổ sung",
          child: Column(
            children: [
              _buildDynamicList(
                "Yêu cầu khóa học",
                requirements,
                onRequirementsChanged,
              ),
              const Divider(height: 32),
              _buildDynamicList(
                "Bạn sẽ học được gì",
                learningPoints,
                onLearningPointsChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicList(
    String title,
    List<String> items,
    VoidCallback onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: items[index],
                    decoration: _inputDecoration(hint: "Nhập nội dung..."),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (v) => items[index] = v,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () {
                    if (items.length > 1) {
                      items.removeAt(index);
                      onChanged();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            items.add('');
            onChanged();
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text("Thêm dòng"),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
