import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/course.dart';
import 'package:elearning_app/models/simple_payment.dart';
import 'package:elearning_app/models/user_model.dart';
import 'package:elearning_app/models/category_firestore.dart';

class DashboardRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<SimplePayment>> getPayments(
    DateTime? start,
    DateTime? end,
  ) async {
    Query query = _firestore.collection('payments').orderBy('date');
    if (start != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start),
      );
    }
    if (end != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(end));
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => SimplePayment.fromSnapshot(doc)).toList();
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<List<Course>> getCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Course.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  Future<List<CategoryFirestoreModel>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryFirestoreModel.fromSnapshot(doc))
        .toList();
  }
}
