import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryFirestoreModel {
  final String id;
  final String name;
  final String icon;
  CategoryFirestoreModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryFirestoreModel(
      id: doc.id,
      name: data['name'] ?? '',
      icon: (data['icon'] ?? ''),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'icon': icon};
  }
}
