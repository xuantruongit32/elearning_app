import 'package:cloud_firestore/cloud_firestore.dart';

class SimplePayment {
  final String id;
  final double amount;
  final Timestamp date;

  final String studentId;
  final String teacherId;
  final String courseId;

  SimplePayment({
    required this.id,
    required this.amount,
    required this.date,
    required this.studentId,
    required this.teacherId,
    required this.courseId,
  });

  factory SimplePayment.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SimplePayment(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      date: data['date'] as Timestamp,
      studentId: data['studentId'] as String,
      teacherId: data['teacherId'] as String,
      courseId: data['courseId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'studentId': studentId,
      'teacherId': teacherId,
      'courseId': courseId,
    };
  }
}
