import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:elearning_app/view/teacher/creat_course/widgets/create_course_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLevel = 'Beginner';
  bool _isPremium = false;
  final List<String> _requirements = [''];
  final List<String> _learningPoints = [''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CreateCourseAppBar(onSubmit: _submitForm),
          SliverToBoxAdapter(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Course Title',
                      hint: 'Enter course title',
                      maxLines: 1,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Description',
                      hint: 'Enter course description',
                      maxLines: 3,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Price',
                          hint: 'Enter price',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildPremiumSwitch(),
                    const SizedBox(height: 32),
                    _buildDynamicList(
                      title: 'Course Requirements',
                      items: _requirements,
                      onRemove: (index) => _requirements.removeAt(index),
                      onAdd: () => _requirements.add(''),
                    ),
                    const SizedBox(height: 32),
                    _buildDynamicList(
                      title: 'What You Will Learn',
                      items: _requirements,
                      onRemove: (index) => _requirements.removeAt(index),
                      onAdd: () => _requirements.add(''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicList({
    required String title,
    required List<String> items,
    required Function(int) onRemove,
    required Function() onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      child: CustomTextField(
                        label: '',
                        hint: 'Enter $title',
                        initialValue: items[index],
                        onChanged: (value) => items[index] = value,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (items.length > 1) {
                          onRemove(index);
                        }
                      });
                    },
                    icon: Icon(Icons.circle_outlined, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              onAdd();
            });
          },
          icon: const Icon(Icons.add),
          label: Text('Add $title'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildPremiumSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Premium Course',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _isPremium,
            onChanged: (value) {
              setState(() {
                _isPremium = value;
              });
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return
    /*
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        */
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          items: ['Beginner', 'Intermediate', 'Advanced']
              .map(
                (level) => DropdownMenuItem(value: level, child: Text(level)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedLevel = value!;
            });
          },
        ),
      ),
    );
    /*
      ],
    );
    */
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_photo_alternate, size: 48),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.back();
    }
  }
}
