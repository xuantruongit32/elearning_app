import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/withdrawal.dart';

class TeacherRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _getUserDoc(String teacherId) {
    return _firestore.collection('users').doc(teacherId);
  }

  CollectionReference<Map<String, dynamic>> _getMainPaymentsCollection() {
    return _firestore.collection('payments');
  }

  CollectionReference<Map<String, dynamic>> _getMainWithdrawalsCollection() {
    return _firestore.collection('withdrawals');
  }

  Stream<double> getBalanceStream(String teacherId) {
    return _getUserDoc(teacherId).snapshots().map((snapshot) {
      if (!snapshot.exists) return 0.0;
      final data = snapshot.data() as Map<String, dynamic>;
      return (data['balance'] as num?)?.toDouble() ?? 0.0;
    });
  }

  Stream<List<SimplePayment>> getPaymentHistoryStream(
    String teacherId, {
    int limit = 20,
  }) {
    return _getMainPaymentsCollection()
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => SimplePayment.fromSnapshot(doc))
              .toList();
        });
  }

  Stream<List<Withdrawal>> getWithdrawalHistoryStream(
    String teacherId, {
    int limit = 20,
  }) {
    return _getMainWithdrawalsCollection() 
        .where('teacherId', isEqualTo: teacherId) 
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => Withdrawal.fromSnapshot(doc))
              .toList();
        });
  }

  Future<void> addDeposit({
    required String teacherId,
    required double amount,
    required String studentId,
    required String courseId,
  }) async {
    if (amount <= 0) throw Exception('Amount must be positive');

    final userRef = _getUserDoc(teacherId);
    final paymentRef = _getMainPaymentsCollection().doc();

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final currentBalance = (snapshot.data())?['balance'] as num? ?? 0.0;

      final newBalance = currentBalance + amount;

      transaction.set(paymentRef, {
        'teacherId': teacherId,
        'studentId': studentId,
        'courseId': courseId,
        'amount': amount,
        'date': Timestamp.now(),
      });

      transaction.set(userRef, {
        'balance': newBalance,
      }, SetOptions(merge: true));
    });
  }

  Future<void> createWithdrawal({
    required String teacherId,
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    if (amount <= 0) throw Exception('Amount must be positive');

    final userRef = _getUserDoc(teacherId);

    final withdrawalRef = _getMainWithdrawalsCollection().doc();

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) throw Exception('User not found');

      final currentBalance = (snapshot.data())?['balance'] as num? ?? 0.0;

      if (currentBalance < amount) {
        throw Exception('Số dư không đủ');
      }

      final newBalance = currentBalance - amount;

      transaction.set(withdrawalRef, {
        'teacherId': teacherId, 
        'amount': amount,
        'date': Timestamp.now(),
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'status': 'pending',
      });

      transaction.update(userRef, {'balance': newBalance});
    });
  }
}
