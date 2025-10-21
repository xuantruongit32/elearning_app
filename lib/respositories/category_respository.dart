import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    try {
      // First get all categories
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();

      // get all courses to count by category
      final coursesSnapshot = await _firestore.collection('courses').get();

      // Create a map to store course counts by category Id
      final Map<String, int> courseCounts = {};

      // Count courses for each category
      for (var course in coursesSnapshot.docs) {
        final categoryId = course.data()['categoryId'] as String?;
        if (categoryId != null) {
          courseCounts[categoryId] = (courseCounts[categoryId] ?? 0) + 1;
        }
      }

      // create category objects with calculated course counts
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
}
