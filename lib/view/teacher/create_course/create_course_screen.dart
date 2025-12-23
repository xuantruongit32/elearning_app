import 'package:better_player_plus/better_player_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/models/prerequisite_course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/services/cloudinary_service.dart';
import 'package:elearning_app/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:elearning_app/view/teacher/create_course/widgets/create_course_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class CreateCourseScreen extends StatefulWidget {
  final Course? course;
  const CreateCourseScreen({super.key, this.course});

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
  List<PrerequisiteCourse> _availableCourses = [];

  List<Map<String, dynamic>> _categories = [];
  bool _isUploadingImage = false;
  Map<int, bool> _isUploadingVideo = {};
  Map<int, bool> _isUploadingResource = {};

  Map<int, BetterPlayerController?> _betterPlayerControllers = {};

  @override
  void initState() {
    _loadCategories();
    super.initState();
    _loadAvailableCourses();
    if (widget.course != null) {
      _initializeCourseData();
    }
  }

  void _initializeCourseData() {
    final course = widget.course!;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _priceController.text = course.price.toString();
    _selectedLevel = course.level;
    _selectedCategoryId = course.categoryId;
    _isPremium = course.isPremium;
    _requirements.clear();
    _requirements.addAll(course.requirements);
    _learningPoints.clear();
    _learningPoints.addAll(course.whatYouWillLearn);
    _lessons.clear();
    _lessons.addAll(course.lessons);
    _courseImageUrl = course.imageUrl;
    _selectedPrerequisites.clear();
    _selectedPrerequisites.addAll(course.prerequisites);
  }

  Future<void> _loadAvailableCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();
      setState(() {
        _availableCourses = snapshot.docs.map((doc) {
          final data = doc.data();
          return PrerequisiteCourse(id: doc.id, title: data['title'] as String);
        }).toList();
      });
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Tải khóa học thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      setState(() {
        _categories = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] as String,
            'icon': data['icon'] as String,
          };
        }).toList();
      });
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Tải danh mục thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    for (var controller in _betterPlayerControllers.values) {
      controller?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              CreateCourseAppBar(onSubmit: _submitForm, course: widget.course),
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
                          label: 'Tiêu đề khóa học',
                          hint: 'Nhập tiêu đề khóa học',
                          maxLines: 1,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tiêu đề';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _descriptionController,
                          label: 'Mô tả',
                          hint: 'Nhập mô tả khóa học',
                          maxLines: 3,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập mô tả';
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
                              label: 'Giá',
                              hint: 'Nhập giá (VND)',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Bắt buộc';
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
                          title: 'Yêu cầu của khóa học',
                          items: _requirements,
                          onRemove: (index) => _requirements.removeAt(index),
                          onAdd: () => _requirements.add(''),
                        ),
                        const SizedBox(height: 32),
                        _buildDynamicList(
                          title: 'Bạn sẽ học được gì',
                          items: _learningPoints,
                          onRemove: (index) => _learningPoints.removeAt(index),
                          onAdd: () => _learningPoints.add(''),
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
          if (_isLoading)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
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
              'Các bài học',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            TextButton.icon(
              onPressed: _addLesson,
              icon: const Icon(Icons.add),
              label: const Text('Thêm bài học'),
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
                  'Bài học ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const Text('Xem trước'),
                        Switch(
                          value: lesson.isPreview,
                          onChanged: (value) =>
                              _updateLesson(index, isPreview: value),
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
              label: 'Tiêu đề bài học',
              hint: 'Nhập tiêu đề bài học',
              initialValue: lesson.title,
              onChanged: (value) => _updateLesson(index, title: value),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Mô tả bài học',
              hint: 'Nhập mô tả bài học',
              maxLines: 3,
              initialValue: lesson.description,
              onChanged: (value) => _updateLesson(index, description: value),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Thời lượng (phút)',
              hint: 'Nhập thời lượng',
              initialValue: lesson.duration == 0
                  ? ''
                  : lesson.duration.toString(),
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
                          ? 'Đang tải lên...'
                          : lesson.videoUrl.isEmpty
                          ? 'Thêm Video'
                          : 'Đổi Video',
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
              'Tài nguyên',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lesson.resources.length,
              itemBuilder: (context, resourceIndex) {
                final resource = lesson.resources[resourceIndex];
                return ListTile(
                  title: Text(resource.title),
                  subtitle: Text(resource.type),
                  trailing: IconButton(
                    onPressed: () => _removeResource(index, resourceIndex),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
            TextButton.icon(
              icon: _isUploadingResource[index] == true
                  ? const SizedBox(height: 20, width: 20)
                  : const Icon(Icons.add),
              onPressed: _isUploadingResource[index] == true
                  ? null
                  : () => _addResource(index),
              label: Text(
                _isUploadingResource[index] == true
                    ? 'Đang tải lên...'
                    : 'Thêm tài nguyên',
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addResource(int lessonIndex) async {
    //code later
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isUploadingResource[lessonIndex] = true;
        });
        final file = result.files.first;
        final resourceUrl = await _cloudinaryService.uploadFile(file.path!);
        final resource = Resource(
          id: const Uuid().v4(),
          title: file.name,
          type: file.extension ?? 'unknown',
          url: resourceUrl,
        );
        setState(() {
          final updatedResources = List<Resource>.from(
            _lessons[lessonIndex].resources,
          )..add(resource);
          _updateLesson(lessonIndex, resources: updatedResources);
          _isUploadingResource[lessonIndex] = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingResource[lessonIndex] = false;
      });
      Get.snackbar(
        'Lỗi',
        'Thêm tài nguyên thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickVideo(int lessonIndex) async {
    try {
      final pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploadingVideo[lessonIndex] = true;
        });
        //upload video to cloudinary
        final videoUrl = await _cloudinaryService.uploadVideo(pickedFile.path);
        //update lesson with new url
        setState(() {
          _lessons[lessonIndex] = _lessons[lessonIndex].copyWith(
            videoUrl: videoUrl,
          );
          //initialize video player after upload
        });
        await _initializeVideoPlayer(lessonIndex, videoUrl);

        setState(() {
          _isUploadingVideo[lessonIndex] = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingVideo[lessonIndex] = false;
      });
      Get.snackbar(
        'Lỗi',
        'Chọn video thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _initializeVideoPlayer(int lessonIndex, String videoUrl) async {
    try {
      _betterPlayerControllers[lessonIndex]?.dispose();

      /*    final videoController = BetterPlayerController(
      BetterPlayerConfiguration(),
      betterPlayerDataSource: BetterPlayerDataSource.network(videoUrl),
    );
final aspectRatio = videoController.getAspectRatio() ?? 1.0; */
      final betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: false,
          looping: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableMute: true,
            showControls: true,
          ),
        ),

        betterPlayerDataSource: BetterPlayerDataSource.network(videoUrl),
      );
      if (mounted) {
        setState(() {
          _betterPlayerControllers[lessonIndex] = betterPlayerController;
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Lỗi',
          'Khởi tạo trình phát thất bại: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _removeResource(int lessonIndex, int resourceIndex) {
    setState(() {
      final updatedResources = List<Resource>.from(
        _lessons[lessonIndex].resources,
      )..removeAt(resourceIndex);
      _updateLesson(lessonIndex, resources: updatedResources);
    });
  }

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
                        hint: 'Nhập $title',
                        initialValue: items[index],
                        onChanged: (value) => items[index] = value,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (items.length > 1 || items[index].isNotEmpty) {
                          onRemove(index);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey[600],
                    ),
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
          label: Text('Thêm $title'),
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
            'Khóa học Premium',
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
          'Điều kiện tiên quyết',
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
              hint: const Text('Chọn khóa học tiên quyết'),
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
                  PrerequisiteCourse(id: courseId, title: 'Khóa học không rõ'),
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
    final Map<String, String> levelMap = {
      'Beginner': 'Cơ bản',
      'Intermediate': 'Trung bình',
      'Advanced': 'Nâng cao',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          items: levelMap.keys
              .map(
                (levelKey) => DropdownMenuItem(
                  value: levelKey,
                  child: Text(levelMap[levelKey]!),
                ),
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
              hint: const Text('Chọn danh mục'),
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
                          'Thêm ảnh bìa khóa học',
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
                  color: Colors.black.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Đổi ảnh bìa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withAlpha(120),
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

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    //validate course thumb
    if (_courseImageUrl == null) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn ảnh bìa khóa học',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }
    //Validate category
    if (_selectedCategoryId == null) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn danh mục',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }
    //validate lesson
    if (_lessons.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng thêm ít nhất một bài học',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }
    String? _lessonError = _validatelessons();
    if (_lessonError != null) {
      Get.snackbar(
        'Lỗi',
        _lessonError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final course = Course(
        id: widget.course?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _courseImageUrl!,
        instructorId: FirebaseAuth.instance.currentUser!.uid,
        categoryId: _selectedCategoryId!,
        price: double.parse(_priceController.text),
        lessons: _lessons,
        level: _selectedLevel,
        isPremium: _isPremium,
        requirements: _requirements.where((r) => r.isNotEmpty).toList(),
        whatYouWillLearn: _learningPoints.where((r) => r.isNotEmpty).toList(),
        createdAt: widget.course?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        prerequisites: _selectedPrerequisites,
        rating: widget.course?.rating ?? 0.0,
        reviewCount: widget.course?.enrollmentCount ?? 0,
        enrollmentCount: widget.course?.enrollmentCount ?? 0,
      );

      if (widget.course != null) {
        await _courseRepository.updateCourse(course);
        context.read<CourseBloc>().add(
          UpdateCourse(FirebaseAuth.instance.currentUser!.uid),
        );
        Get.back();
        Get.snackbar(
          'Thành công',
          'Cập nhật khóa học thành công',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      } else {
        await _courseRepository.createCourse(course);
        Get.back();
        Get.snackbar(
          'Thành công',
          'Tạo khóa học thành công',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Tạo khóa học thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validatelessons() {
    for (int i = 0; i < _lessons.length; i++) {
      final lesson = _lessons[i];

      // validate lesson title
      if (lesson.title.isEmpty) {
        return 'Vui lòng nhập tiêu đề cho Bài học ${i + 1}';
      }

      // validate lesson description
      if (lesson.description.isEmpty) {
        return 'Vui lòng nhập mô tả cho Bài học ${i + 1}';
      }

      //validate lesson video
      if (lesson.videoUrl.isEmpty) {
        return 'Vui lòng tải video lên cho Bài học ${i + 1}';
      }
      //validate lesson video
      if (lesson.duration <= 0) {
        return 'Vui lòng nhập thời lượng hợp lệ cho Bài học ${i + 1}';
      }
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        setState(() {
          _courseImagePath = pickedFile.path;
          _isUploadingImage = true;
        });
        //upload image to cloudinary
        final imageUrl = await _cloudinaryService.uploadImage(
          pickedFile.path,
          'course_images',
        );
        setState(() {
          _courseImageUrl = imageUrl;
          _isUploadingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      Get.snackbar(
        'Lỗi',
        'Chọn ảnh thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
}
