import 'package:elearning_app/bloc/auth/auth_bloc.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/respositories/instructor_respositories.dart';
import 'package:elearning_app/services/certificate_service.dart';
import 'package:elearning_app/view/certificate/certificate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CertificatePreviewScreen extends StatefulWidget {
  final Course course;
  const CertificatePreviewScreen({super.key, required this.course});

  @override
  State<CertificatePreviewScreen> createState() =>
      _CertificatePreviewScreenState();
}

class _CertificatePreviewScreenState extends State<CertificatePreviewScreen> {
  final GlobalKey certificateKey = GlobalKey();
  bool _isGenerating = false;
  final TransformationController _transformationController =
      TransformationController();
  final InstructorRepository _instructorRepository = InstructorRepository();
  String _instructorName = 'Giảng viên khóa học';

  @override
  void initState() {
    super.initState();
    _loadInstructorName();
  }

  Future<void> _loadInstructorName() async {
    try {
      final instructor = await _instructorRepository.getInstructorById(
        widget.course.instructorId,
      );

      if (instructor != null && mounted) {
        setState(() {
          _instructorName = instructor.fullName ?? 'Giảng viên khóa học';
        });
      }
    } catch (e) {
      print('Lỗi khi tải tên giảng viên: $e');
    }
  }

  Future<void> _downloadCertificate() async {
    if (_isGenerating) return;
    setState(() {
      _isGenerating = true;
    });
    try {
      final studentName =
          context.read<AuthBloc>().state.userModel?.fullName ?? 'Học viên';

      final certificateBytes = await CertificateService.generateCertificate(
        course: widget.course,
        studentName: studentName,
        instructorName: _instructorName,
        certificateKey: certificateKey,
      );

      if (certificateBytes != null) {
        final success = await CertificateService.saveCertificate(
          certificateBytes,
        );
        if (success) {
          Get.snackbar(
            'Thành công',
            'Chứng chỉ đã được lưu vào thư viện ảnh',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Lỗi',
            'Không thể lưu chứng chỉ',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể lưu chứng chỉ',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem trước chứng chỉ'),
        actions: [
          if (!_isGenerating)
            IconButton(
              onPressed: () {
                _transformationController.value = Matrix4.identity();
              },
              icon: const Icon(Icons.zoom_out),
              tooltip: 'Thu nhỏ',
            ),
          if (!_isGenerating)
            IconButton(
              onPressed: _downloadCertificate,
              icon: const Icon(Icons.download),
              tooltip: 'Tải chứng chỉ',
            ),
        ],
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 2.0,
            child: Center(
              child: CertificateWidget(
                course: widget.course,
                studentName:
                    context.read<AuthBloc>().state.userModel?.fullName ??
                    'Học viên',
                instructorName: _instructorName,
                certificateKey: certificateKey,
              ),
            ),
          ),
          if (_isGenerating)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Đang tạo chứng chỉ...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
