import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic('dygc3825n', 'tt-elearning-app');

  Future<String> uploadImage(String imagePath) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath, folder: 'profile_pictures'),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
