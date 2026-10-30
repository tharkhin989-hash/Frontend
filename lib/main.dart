import 'package:exe/screen/category_form.dart';
import 'package:exe/screen/user-table.dart';
import 'package:exe/screen/user_api.dart';
import 'package:exe/screen/user_form.dart';
import 'package:exe/screen/user_list.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_exe/lib/screen/stl.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserForm()
    );
  }
}