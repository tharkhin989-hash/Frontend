//import 'package:exe/model/category_data.dart';
import 'package:exe/model/get_category_data.dart';
import 'package:flutter/material.dart';

class MyCategory extends StatelessWidget {
  const MyCategory({super.key});

  static const categories = [
    Category(
      name: 'Electronics',
      description: 'Electronic devices and accessories',
      categoryId: 1,
    ),
    Category(
      name: 'Clothing',
      description: 'Clothes and fashion accessories', 
      categoryId: 2,
    ),
    Category(
      name: 'Books',
      description: 'Books, novels, and educational materials', 
      categoryId: 3, 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.category),
              ),
              title: Text(category.name),
              subtitle: Text(category.description),
            ),
          );
        },
      ),
    );
  }
}