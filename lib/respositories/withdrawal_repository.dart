import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/withdrawal.dart';

class WithdrawalRepository {
  final _firestore = FirebaseFirestore.instance;

  // Lấy toàn bộ danh sách rút tiền 
  Future<List<Withdrawal>> getWithdrawals() async {
    try {
      final snapshot = await _firestore
          .collection('withdrawals')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) => Withdrawal.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get withdrawals: $e');
    }
  }

  // Duyệt yêu cầu 
  Future<void> approveWithdrawal(String id) async {
    await _firestore.collection('withdrawals').doc(id).update({
      'status': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectWithdrawal(String withdrawalId, String teacherId, double amount) async {
    final withdrawalRef = _firestore.collection('withdrawals').doc(withdrawalId);
    final userRef = _firestore.collection('users').doc(teacherId);

    return _firestore.runTransaction((transaction) async {
      //lấy số dư hiện tại
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) throw Exception('User not found');
      
      final currentBalance = (userSnapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;

      // rejected
      transaction.update(withdrawalRef, {
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      //Hoàn tiền 
      transaction.update(userRef, {
        'balance': currentBalance + amount,
      });
    });
  }
}