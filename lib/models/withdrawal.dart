import 'package:cloud_firestore/cloud_firestore.dart';

class Withdrawal {
  final String id;
  final String teacherId;
  final double amount;
  final Timestamp date;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String status;

  Withdrawal({
    required this.id,
    required this.teacherId,
    required this.amount,
    required this.date,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    this.status = 'pending',
  });

  factory Withdrawal.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Withdrawal(
      id: doc.id,
      teacherId: data['teacherId'] as String,
      amount: (data['amount'] as num).toDouble(),
      date: data['date'] as Timestamp,
      bankName: data['bankName'] as String,
      accountNumber: data['accountNumber'] as String,
      accountName: data['accountName'] as String,
      status: data['status'] as String? ?? 'pending',
    );
  }
}
