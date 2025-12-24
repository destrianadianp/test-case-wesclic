import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../core/models/user_model.dart';
import '../../../core/services/mock_data.dart';
import '../../../core/services/api_header.dart';

class HomeApiService {
  Future<List<UserModel>> getTopUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return allUsers.take(3).toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    debugPrint('Attempting to fetch all users');
    final urlAllUsers = Uri.parse('https://reqres.in/api/users?page=2');
    final response = await http.get(
      urlAllUsers,
      headers: ApiHeader.headers,
    );
    debugPrint('Get all users response status: ${response.statusCode}');
    debugPrint('Get all users response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final listUser = data['data'];
      debugPrint('Successfully fetched ${listUser.length} users');
      return List<UserModel>.from(
        listUser.map((user) => UserModel(
          id: user['id'].toString(),
          name: '${user['first_name']} ${user['last_name']}',
          email: user['email'],
          imageUrl: user['avatar'],
          job: user['job'], // Add job field parsing
        )),
      );
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      debugPrint('Get all users failed with error: ${data['error'] ?? 'Kredensial tidak valid.'}');
      throw Exception(data['error'] ?? 'Kredensial tidak valid.');
    } else {
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }
}