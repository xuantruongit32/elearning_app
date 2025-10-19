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
import 'package:uuid/uuid.dart';

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
  List<String> _selectedPrerequisites = [];
  List<PrerequisiteCourse> _availableCourses = [
    PrerequisiteCourse(id: '1', title: 'Flutter Fundamentals'),
    PrerequisiteCourse(id: '2', title: 'Dart Pro Language'),
    PrerequisiteCourse(id: '3', title: 'Mobile App Development'),
  ];

  List<Map<String, dynamic>> _categories = [
    {
      'id': '1',
      'name': 'Programming',
      'icon': '0xe86f', // code
    },
    {
      'id': '2',
      'name': 'Data Science',
      'icon': '0xe6b1', // analytics
    },
    {
      'id': '3',
      'name': 'Design',
      'icon': '0xe3ae', // brush
    },
    {
      'id': '4',
      'name': 'Business',
      'icon': '0xeb3f', // business_center
    },
    {
      'id': '5',
      'name': 'Music',
      'icon': '0xe405', // music_note
    },
    {
      'id': '6',
      'name': 'Photography',
      'icon': '0xe412', // photo_camera
    },
    {
      'id': '7',
      'name': 'Language',
      'icon': '0xe894', // language
    },
    {
      'id': '8',
      'name': 'Personal Development',
      'icon': '0xea78', // self_improvement
    },
  ];
  bool _isUploadingImage = false;
  Map<int, bool> _isUploadingVideo = {};
  Map<int, bool> _isUploadingResource = {};

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
                        const SizedBox(height: 24),
                        _buildPrerequisitesDropdown(),
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
                        const SizedBox(height: 32),
                        _buildLessonsSection(),
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

  Widget _buildLessonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Course Lessons',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            TextButton.icon(
              onPressed: _addLesson,
              icon: const Icon(Icons.add),
              label: const Text('Add Lesson'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _lessons.length,
          itemBuilder: (context, index) {
            return _buildLessonCard(_lessons[index], index);
          },
        ),
      ],
    );
  }

  void _addLesson() {
    setState(() {
      _lessons.add(
        Lesson(
          id: const Uuid().v4(),
          title: '',
          description: '',
          videoUrl: '',
          duration: 0,
          resources: [],
          isPreview: false,
        ),
      );
    });
  }

  Widget _buildLessonCard(Lesson lesson, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lesson ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const Text('Preview'),
                        Switch(
                          value: lesson.isPreview,
                          onChanged: (value) =>
                              _updateLesson(index, isPreview: true),
                          activeThumbColor: AppColors.primary,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _removeLesson(index),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Lesson Title',
              hint: 'Enter lesson title',
              initialValue: lesson.title,
              onChanged: (value) => _updateLesson(index, title: value),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Lesson Description',
              hint: 'Enter lesson description',
              maxLines: 3,
              onChanged: (value) => _updateLesson(index, title: value),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Duration (minutes)',
              hint: 'Enter duration',
              initialValue: lesson.duration.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateLesson(
                index,
                duration: int.tryParse(value ?? '0') ?? 0,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploadingVideo[index] == true
                        ? null
                        : () => _pickVideo(index),
                    icon: _isUploadingVideo[index] == true
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.video_library),
                    label: Text(
                      _isUploadingVideo[index] == true
                          ? 'Uploading...'
                          : lesson.videoUrl.isEmpty
                          ? 'Add Video'
                          : 'Change Video',
                    ),
                  ),
                ),
              ],
            ),

            //add video preview if available
            if (lesson.videoUrl.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final aspectRation =
                      _betterPlayerControllers[index]
                          ?.videoPlayerController
                          ?.value
                          .aspectRatio ??
                      16 / 9;
                  final height = maxWidth / aspectRation;

                  return Container(
                    width: maxWidth,
                    height: height.clamp(
                      200,
                      MediaQuery.of(context).size.height * 0.4,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _betterPlayerControllers[index] != null
                          ? BetterPlayer(
                              controller: _betterPlayerControllers[index]!,
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            const Text(
              'Resources',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideo(int lessonIndex) async {}

  void _removeLesson(int index) {
    setState(() {
      _betterPlayerControllers[index]?.dispose();
      _betterPlayerControllers.remove(index);
      _lessons.removeAt(index);
    });
  }

  void _updateLesson(
    int index, {
    String? title,
    String? description,
    String? videoUrl,
    int? duration,
    List<Resource>? resources,
    bool? isPreview,
  }) {
    setState(() {
      _lessons[index] = _lessons[index].copyWith(
        title: title,
        description: description,
        videoUrl: videoUrl,
        duration: duration,
        resources: resources,
        isPreview: isPreview,
      );
    });
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

  Widget _buildPrerequisitesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prerequisites',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select Prerequisites'),
              value: null,
              items: _availableCourses.map<DropdownMenuItem<String>>((course) {
                return DropdownMenuItem<String>(
                  value: course.id,
                  child: Text(course.title),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null &&
                    !_selectedPrerequisites.contains(newValue)) {
                  setState(() {
                    _selectedPrerequisites.add(newValue);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _selectedPrerequisites.map((courseId) {
            final course = _availableCourses.firstWhere(
              (c) => c.id == courseId,
              orElse: () =>
                  PrerequisiteCourse(id: courseId, title: 'Unknown Course'),
            );

            return Chip(
              label: Text(course.title),
              onDeleted: () {
                setState(() {
                  _selectedPrerequisites.remove(courseId);
                });
              },
            );
          }).toList(),
        ),
      ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      Icon(
                        _getIconData(category['icon'] as String),
                        color: AppColors.primary,
                      ),
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

  IconData _getIconData(String iconCode) {
    return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
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
