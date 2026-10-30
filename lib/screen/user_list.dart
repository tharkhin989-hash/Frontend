import 'package:exe/model/user_data.dart';
import 'package:flutter/material.dart';

class MyHat extends StatelessWidget {
  const MyHat({super.key});

  static const users = [
    User(
      name: 'Aung Aung',
      email: 'aung@gmail.com',
      role: 'admin',
    ),
    User(
       name: 'Su Su',
      email: 'Su@gmail.com',
      role: 'admin',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Text(user.role),
          ),
          );
        },
      ),
    );  

  }
}