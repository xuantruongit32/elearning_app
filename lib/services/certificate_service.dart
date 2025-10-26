import 'dart:typed_data';
import 'package:elearning_app/models/course.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class CertificateService {
  static Future<Uint8List?> generateCertificate({
    required Course course,
    required String studentName,
    required String instructorName,
    required GlobalKey certificateKey,
  }) async {
    try {
      RenderRepaintBoundary boundary =
          certificateKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveCertificate(Uint8List certificateBytes) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        certificateBytes,
        name: 'certificate_${DateTime.now().millisecondsSinceEpoch}',
        quality: 100,
      );
      return result['isSuccess'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
