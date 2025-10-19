import 'package:better_player_plus/better_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/models/prerequisite_course.dart';
import 'package:elearning_app/respositories/course_respository.dart';
import 'package:elearning_app/services/cloudinary_service.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:elearning_app/view/teacher/create_course/widgets/create_course_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

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
  final _courseRepository = CourseRepository();
  final _cloudinaryService = CloudinaryService();
  final _imagePicker = ImagePicker();
  final _firestore = FirebaseFirestore.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  final List<Lesson> _lessons = [];
  String? _courseImagePath;
  String? _courseImageUrl;
  bool _isLoading = false;
  List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Programming', 'icon': Icons.code.codePoint},
    {'id': '2', 'name': 'Data Science', 'icon': Icons.analytics.codePoint},
    {'id': '3', 'name': 'Design', 'icon': Icons.brush.codePoint},
    {'id': '4', 'name': 'Business', 'icon': Icons.business_center.codePoint},
    {'id': '5', 'name': 'Music', 'icon': Icons.music_note.codePoint},
    {'id': '6', 'name': 'Photography', 'icon': Icons.photo_camera.codePoint},
    {'id': '7', 'name': 'Language', 'icon': Icons.language.codePoint},
    {
      'id': '8',
      'name': 'Personal Development',
      'icon': Icons.self_improvement.codePoint,
    },
  ];
  bool _isUploadingImage = false;
  Map<int, bool> _isUploadingVideo = {};
  Map<int, bool> _isUploadingResource = {};
  List<PrerequisiteCourse> _availableCourse = [];
  List<String> _selectedPrerequisites = [];
  Map<int, BetterPlayerController?> _betterPlayerControllers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              CreateCourseAppBar(onSubmit: _submitForm),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildImagePicker(),
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _titleController,
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
                          controller: _descriptionController,
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
                              controller: _priceController,
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
                        _buildCategoryDropdown(),
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
    return Container(
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
  }

  Widget _buildCategoryDropdown() {
    return Column(
      children: [
        // Text(
        //   'Category',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     color: AppColors.primary,
        //   ),
        // ),
        // const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedCategoryId,
              isExpanded: true,
              hint: const Text('Select Category'),
              items: _categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['id'] as String,
                  child: Row(
                    children: [
                      const Icon(Icons.category, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(category['name'] as String),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                  _selectedCategoryName =
                      _categories.firstWhere(
                            (cat) => cat['id'] == value,
                          )['name']
                          as String;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: _courseImageUrl != null && !_isUploadingImage
                  ? DecorationImage(
                      image: NetworkImage(_courseImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _isUploadingImage
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                  )
                : _courseImageUrl == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Add Course Thumbnail',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          if (_courseImageUrl != null && !_isUploadingImage)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Change Thumbnail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.back();
    }
  }

  Future<void> _pickImage() async {}
}
