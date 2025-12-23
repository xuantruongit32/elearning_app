import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/category.dart';
import 'package:elearning_app/models/category_firestore.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriesCollection = FirebaseFirestore.instance
      .collection('categories');

  Future<List<Category>> getCategories() async {
    try {
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();

      final coursesSnapshot = await _firestore.collection('courses').get();

      final Map<String, int> courseCounts = {};

      for (var course in coursesSnapshot.docs) {
        final categoryId = course.data()['categoryId'] as String?;
        if (categoryId != null) {
          courseCounts[categoryId] = (courseCounts[categoryId] ?? 0) + 1;
        }
      }

      return categoriesSnapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: doc.id,
          name: data['name'] as String,
          icon: IconData(
            int.parse(data['icon'] as String),
            fontFamily: 'MaterialIcons',
          ),
          courseCount: courseCounts[doc.id] ?? 0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<int> getCourseCount(String categoryId) async {
    final query = FirebaseFirestore.instance
        .collection('courses')
        .where('categoryId', isEqualTo: categoryId);

    final countSnapshot = await query.count().get();
    return countSnapshot.count ?? 0;
  }

  Stream<List<CategoryFirestoreModel>> getCategoriesforWeb() {
    return _categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryFirestoreModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addCategory(CategoryFirestoreModel category) {
    return _categoriesCollection.add(category.toFirestore());
  }

  Future<void> updateCategory(CategoryFirestoreModel category) {
    return _categoriesCollection
        .doc(category.id)
        .update(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) {
    return _categoriesCollection.doc(categoryId).delete();
  }
}
