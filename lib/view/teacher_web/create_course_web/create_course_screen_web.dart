import 'package:chewie/chewie.dart'; // Thay thế BetterPlayer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/bloc/course/course_bloc.dart';
import 'package:elearning_app/bloc/course/course_event.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/lesson.dart';
import 'package:elearning_app/models/prerequisite_course.dart';
import 'package:elearning_app/respositories/course_repository.dart';
import 'package:elearning_app/services/cloudinary_service.dart';
import 'package:elearning_app/view/teacher_web/create_course_web/widgets/web_course_info_section.dart';
import 'package:elearning_app/view/teacher_web/create_course_web/widgets/web_course_settings_sidebar.dart';
import 'package:elearning_app/view/teacher_web/create_course_web/widgets/web_create_course_app_bar.dart';
import 'package:elearning_app/view/teacher_web/create_course_web/widgets/web_lesson_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart'; 

class CreateCourseScreenWeb extends StatefulWidget {
  final Course? course;
  const CreateCourseScreenWeb({super.key, this.course});

  @override
  State<CreateCourseScreenWeb> createState() => _CreateCourseScreenWebState();
}

class _CreateCourseScreenWebState extends State<CreateCourseScreenWeb> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedLevel = 'Beginner';
  bool _isPremium = false;
  String? _selectedCategoryId;
  String? _courseImageUrl;
  String? _courseImagePath;

  final List<String> _requirements = [''];
  final List<String> _learningPoints = [''];
  final List<Lesson> _lessons = [];
  List<String> _selectedPrerequisites = [];

  List<Map<String, dynamic>> _categories = [];
  List<PrerequisiteCourse> _availableCourses = [];

  bool _isLoading = false;
  bool _isUploadingImage = false;
  final Map<int, bool> _isUploadingVideo = {};
  final Map<int, bool> _isUploadingResource = {};

  final Map<int, VideoPlayerController> _videoPlayerControllers = {};
  final Map<int, ChewieController?> _chewieControllers = {};

  final _courseRepository = CourseRepository();
  final _cloudinaryService = CloudinaryService();
  final _imagePicker = ImagePicker();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    _loadCategories();
    super.initState();
    _loadAvailableCourses();
    if (widget.course != null) {
      _initializeCourseData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    for (var controller in _videoPlayerControllers.values) {
      controller.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller?.dispose();
    }
    super.dispose();
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

    for (int i = 0; i < _lessons.length; i++) {
      if (_lessons[i].videoUrl.isNotEmpty) {
        _initializeVideoPlayer(i, _lessons[i].videoUrl);
      }
    }
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
      print("Error loading courses: $e");
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
      print("Error loading categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: WebCreateCourseAppBar(
        isEditMode: widget.course != null,
        isLoading: _isLoading,
        onBack: () => Get.back(),
        onSave: _submitForm,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    WebCourseInfoSection(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      imageUrl: _courseImageUrl,
                      isUploadingImage: _isUploadingImage,
                      onPickImage: _pickImage,
                    ),
                    const SizedBox(height: 24),
                    WebLessonManager(
                      lessons: _lessons,
                      isUploadingVideo: _isUploadingVideo,
                      isUploadingResource: _isUploadingResource,
                      chewieControllers:
                          _chewieControllers, 
                      onAddLesson: _addLesson,
                      onRemoveLesson: _removeLesson,
                      onUpdateLesson: _updateLesson,
                      onPickVideo: _pickVideo,
                      onAddResource: _addResource,
                      onRemoveResource: _removeResource,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                flex: 3,
                child: WebCourseSettingsSidebar(
                  priceController: _priceController,
                  selectedLevel: _selectedLevel,
                  selectedCategoryId: _selectedCategoryId,
                  isPremium: _isPremium,
                  categories: _categories,
                  availableCourses: _availableCourses,
                  selectedPrerequisites: _selectedPrerequisites,
                  requirements: _requirements,
                  learningPoints: _learningPoints,
                  onLevelChanged: (val) =>
                      setState(() => _selectedLevel = val!),
                  onCategoryChanged: (val) =>
                      setState(() => _selectedCategoryId = val),
                  onPremiumChanged: (val) => setState(() => _isPremium = val),
                  onPrerequisiteChanged: (val) {
                    if (val != null && !_selectedPrerequisites.contains(val)) {
                      setState(() => _selectedPrerequisites.add(val));
                    }
                  },
                  onRemovePrerequisite: (val) =>
                      setState(() => _selectedPrerequisites.remove(val)),
                  onRequirementsChanged: () => setState(() {}),
                  onLearningPointsChanged: () => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _courseImagePath = pickedFile.path;
          _isUploadingImage = true;
        });
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
      setState(() => _isUploadingImage = false);
      Get.snackbar(
        'Lỗi',
        'Chọn ảnh thất bại: $e',
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
        setState(() => _isUploadingVideo[lessonIndex] = true);
        final videoUrl = await _cloudinaryService.uploadVideo(pickedFile.path);
        setState(() {
          _lessons[lessonIndex] = _lessons[lessonIndex].copyWith(
            videoUrl: videoUrl,
          );
        });
        await _initializeVideoPlayer(lessonIndex, videoUrl);
        setState(() => _isUploadingVideo[lessonIndex] = false);
      }
    } catch (e) {
      setState(() => _isUploadingVideo[lessonIndex] = false);
      Get.snackbar(
        'Lỗi',
        'Upload video thất bại: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _initializeVideoPlayer(int lessonIndex, String videoUrl) async {
    try {
      _chewieControllers[lessonIndex]?.dispose();
      _videoPlayerControllers[lessonIndex]?.dispose();

      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await videoPlayerController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _videoPlayerControllers[lessonIndex] = videoPlayerController;
          _chewieControllers[lessonIndex] = chewieController;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Video Init Error: $e');
      }
    }
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

  void _removeLesson(int index) {
    setState(() {
      _videoPlayerControllers[index]?.dispose();
      _videoPlayerControllers.remove(index);

      _chewieControllers[index]?.dispose();
      _chewieControllers.remove(index);

      _lessons.removeAt(index);
    });
  }

  Future<void> _addResource(int lessonIndex) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _isUploadingResource[lessonIndex] = true);

        final file = result.files.first;
        final path = file.path ?? '';

        final resourceUrl = await _cloudinaryService.uploadFile(path);

        final resource = Resource(
          id: const Uuid().v4(),
          title: file.name,
          type: file.extension ?? 'unknown',
          url: resourceUrl,
        );
        setState(() {
          final updated = List<Resource>.from(_lessons[lessonIndex].resources)
            ..add(resource);
          _updateLesson(lessonIndex, resources: updated);
          _isUploadingResource[lessonIndex] = false;
        });
      }
    } catch (e) {
      setState(() => _isUploadingResource[lessonIndex] = false);
      Get.snackbar('Lỗi', 'Thêm tài nguyên thất bại: $e');
    }
  }

  void _removeResource(int lessonIndex, int resourceIndex) {
    setState(() {
      final updated = List<Resource>.from(_lessons[lessonIndex].resources)
        ..removeAt(resourceIndex);
      _updateLesson(lessonIndex, resources: updated);
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_courseImageUrl == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn ảnh bìa');
      return;
    }
    if (_selectedCategoryId == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn danh mục');
      return;
    }
    if (_lessons.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng thêm bài học');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final courseData = Course(
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
        reviewCount: widget.course?.reviewCount ?? 0,
        enrollmentCount: widget.course?.enrollmentCount ?? 0,
      );

      if (widget.course != null) {
        await _courseRepository.updateCourse(courseData);
        context.read<CourseBloc>().add(
          UpdateCourse(FirebaseAuth.instance.currentUser!.uid),
        );
        Get.back();
        Get.snackbar(
          'Thành công',
          'Cập nhật thành công',
          backgroundColor: Colors.green[100],
        );
      } else {
        await _courseRepository.createCourse(courseData);
        Get.back();
        Get.snackbar(
          'Thành công',
          'Tạo mới thành công',
          backgroundColor: Colors.green[100],
        );
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Thất bại: $e', backgroundColor: Colors.red[100]);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
