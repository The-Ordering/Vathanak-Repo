import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryHomeModel{
  final Color color;
  final IconData iconData;
  final String name;
  int count;

  CategoryHomeModel({required this.color, required this.iconData, required this.name, required this.count});

  static List<CategoryHomeModel> categoryHomeList = [
    CategoryHomeModel(color: Color(0XFFB4C4FF), iconData: Icons.folder_copy_outlined, name: 'All Tasks', count: 0),
    CategoryHomeModel(color: Color(0xFFCFF3E9), iconData: Icons.work_outline, name: 'Work', count: 0),
    CategoryHomeModel(color: Color(0x999747FF).withOpacity(0.6), iconData: Icons.task_outlined, name: 'Education', count: 0),
    CategoryHomeModel(color: Color(0x99EDBE7D), iconData: Icons.shopping_cart_outlined, name: 'Groceries', count: 0),
  ];

  static void updateCategoryCounts(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    // Clear previous counts
    for (var category in categoryHomeList) {
      category.count = 0;  // Reset count for each category
    }

    // Loop through the documents to update counts
    for (var doc in docs) {
      String categoryName = doc.get("category").toString();

      // Find the category in the list and increment its count
      CategoryHomeModel? category = categoryHomeList.firstWhere(
              (category) => category.name == categoryName,
          orElse: () => CategoryHomeModel(color: Colors.transparent, iconData: Icons.error, name: 'Unknown', count: 0)
      );

      category.count++;  // Increment count for the found category
    }
  }
}