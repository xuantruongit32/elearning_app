import 'package:elearning_app/core/theme/app_colors.dart';
import 'package:elearning_app/models/course.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificateWidget extends StatelessWidget {
  final Course course;
  final String studentName;
  final String instructorName;
  final GlobalKey certificateKey;

  const CertificateWidget({
    super.key,
    required this.course,
    required this.studentName,
    required this.instructorName,
    required this.certificateKey,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final certificateWidth = screenSize.width * 0.9; // 90% of screen width
    final certificateHeight = certificateWidth * 0.85;
    final scale =
        certificateWidth / 800; // scale factor based on original design
    return RepaintBoundary(
      key: certificateKey,
      child: Container(
        width: certificateWidth,
        height: certificateHeight,
        padding: EdgeInsets.all(20 * scale),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primary, width: 8 * scale),
          borderRadius: BorderRadius.circular(20 * scale),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CHỨNG NHẬN',
              style: TextStyle(
                fontSize: 48 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 8 * scale,
              ),
            ),
            Text(
              'HOÀN THÀNH KHÓA HỌC',
              style: TextStyle(
                fontSize: 28 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
                letterSpacing: 4 * scale,
              ),
            ),
            SizedBox(height: 40 * scale),
            Text(
              'Chứng nhận rằng',
              style: TextStyle(fontSize: 24 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 20 * scale),
            Text(
              studentName,
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20 * scale),
            Text(
              'đã hoàn thành xuất sắc khóa học',
              style: TextStyle(fontSize: 20 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 20 * scale),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 30 * scale),
            Text(
              'Hoàn thành vào ngày ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 18 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 40 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 150 * scale,
                      height: 2 * scale,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8 * scale),
                    Text(
                      instructorName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Giảng viên khóa học',
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/certificate.png',
                  width: 100 * scale,
                  height: 100 * scale,
                ),
                Column(
                  children: [
                    Container(
                      width: 150 * scale,
                      height: 2 * scale,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8 * scale),
                    Text(
                      'Hoàng Trường',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Giám đốc nền tảng',
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
