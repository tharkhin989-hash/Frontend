import 'package:flutter/foundation.dart';

class Category{
  final int categoryId;
  final String name;
  final String description;
 
  const Category({
    required this.categoryId,
    required this.name,
    required this.description, 
   
  });

factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: int.parse(json['category_id'].toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
     
    );
  }
}