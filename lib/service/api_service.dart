import 'dart:convert';

import 'package:exe/config/app_config.dart';
//import 'package:exe/model/creat_category_model.dart';
import 'package:exe/model/creat_user_model.dart';
//import 'package:exe/model/get_category_data.dart';
import 'package:exe/model/get_user_data.dart';
import 'package:exe/model/update_user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<List<User>> fetchUsers() async {
    final url=Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/users/',
    );
    final response=await http.get(url);

    if(response.statusCode==200){
      final decoded =jsonDecode(response.body);

      final List<dynamic> data =
        decoded is List ? decoded : decoded['results'];
      return data
        .map((item) => User.fromJson(item))
        .toList();
    }
    throw Exception(   
     'Failed to load user data: ${response.statusCode}',
    );
  }
  
   Future<void> deleteUser(int user_Id) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/v1/intern/users/$user_Id/');
    final response = await http.delete(
      url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
    Future<User> createUser(CreateUser user) async {
     final url= Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/users/',

     );
     final response= await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(user.toJson()),
     );
     if (response.statusCode == 200 ||
        response.statusCode == 201){
          return User.fromJson(jsonDecode(response.body));
          
        }
        throw Exception(
          'Failed to create user: ${response.statusCode} ${response.body}',
        );
    }
Future<void> updateUser({
  required int userId,
  required UpdateUser user,
  
}) async{
  final url = Uri.parse(
    '${AppConfig.baseUrl}/api/v1/intern/users/$userId/',
  );
  final response= await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
  body: jsonEncode(user.toJson()),
  );
   if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204){
          return;
  }
    throw Exception(
          'Failed to update user:'
          ' ${response.statusCode} ${response.body}',
        );
    }
}