import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/simple_payment.dart';

class PaymentRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<SimplePayment>> getPayments() async {
    try {
      final snapshot = await _firestore
          .collection('payments')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return SimplePayment.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get payments: $e');
    }
  }
}
