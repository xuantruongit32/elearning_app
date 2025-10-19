import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic('dygc3825n', 'tt-elearning-app');

  Future<String> uploadImage(String imagePath, String folder) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath, folder: folder),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> uploadVideo(String videoPath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          videoPath,
          folder: 'course_videos',
          resourceType: CloudinaryResourceType.Video,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  Future<String> uploadFile(String filePath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath, folder: 'course_resources'),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
