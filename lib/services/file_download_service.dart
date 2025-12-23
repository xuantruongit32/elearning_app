import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FileDownloadService {
  Future<String> downloadFile(String url, String filename) async {
    try {
      // check android version
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 30) {
        // for android 11 and above, need to request storage permission
        if (!await Permission.manageExternalStorage.isGranted) {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            throw Exception(
              'Storage permission denied. Please grant permission in app settings.',
            );
          }
        }
      } else {
        // for android 10 and below, we need storage permission
        if (!await Permission.storage.isGranted) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception(
              'Storage permission denied. Please grant permission in app settings.',
            );
          }
        }
      }

      // Get the downloads directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access external storage');
      }

      // create a downloads folder if it doesn't exist
      final downloadDir = Directory('${directory.path}/Downloads');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      // save the file
      final filePath = '${downloadDir.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return filePath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      throw Exception('Failed to open file: $e');
    }
  }
}
