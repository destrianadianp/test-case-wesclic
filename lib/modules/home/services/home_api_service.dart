import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/models/user_model.dart';
import '../../../core/services/mock_data.dart';

class HomeApiService {
  Future<List<UserModel>> getTopUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return allUsers.take(3).toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    print('Attempting to fetch all users');
    final urlAllUsers = Uri.parse('https://reqres.in/api/users?page=2');
    final response = await http.get(
      urlAllUsers,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
    );
    print('Get all users response status: ${response.statusCode}');
    print('Get all users response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final listUser = data['data'];
      print('Successfully fetched ${listUser.length} users');
      return List<UserModel>.from(
        listUser.map((user) => UserModel.fromJson(user)),
      );
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      print('Get all users failed with error: ${data['error'] ?? 'Kredensial tidak valid.'}');
      throw Exception(data['error'] ?? 'Kredensial tidak valid.');
    } else {
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }
}