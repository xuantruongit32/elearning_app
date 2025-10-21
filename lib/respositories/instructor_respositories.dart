import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/user_model.dart';

class InstructorRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getInstructorById(String instructorId) async {
    try {
      final doc = await _firestore.collection('users').doc(instructorId).get();
      if (!doc.exists) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get instructor: $e');
    }
  }

  
}
