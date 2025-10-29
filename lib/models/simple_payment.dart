import 'package:cloud_firestore/cloud_firestore.dart';

class SimplePayment {
  final String id;
  final double amount;
  final Timestamp date;

  SimplePayment({required this.id, required this.amount, required this.date});

  factory SimplePayment.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SimplePayment(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      date: data['date'] as Timestamp,
    );
  }
}
