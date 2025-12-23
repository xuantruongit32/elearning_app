import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      //batch để gom các lệnh xóa lại thực hiện 1 lần
      WriteBatch batch = _firestore.batch();

      // tìm tất cả khóa học do user này tạo
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('instructorId', isEqualTo: uid) //
          .get();

      //  cho từng khóa học tìm thấy vào batch
      for (var doc in coursesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // thêm lệnh xóa chính user đó vào batch
      final userRef = _firestore.collection('users').doc(uid);
      batch.delete(userRef);

      // xóa
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user and their courses: $e');
    }
  }

  Future<double> getTotalSpentByStudent(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('payments')
          .where('studentId', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['amount'] as num? ?? 0).toDouble();
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }
}
