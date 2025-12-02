import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/mock_data.dart';
import 'package:http/http.dart' as http;

class LoginMockService {
  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('https://reqres.in/api/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return UserModel.fromLoginResponse(email, token);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Kredensial tidak valid.');
    } else {
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }

  Future<List<UserModel>> getTopUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return allUsers.take(3).toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return allUsers;
  }

  Future<UserModel> getUserDetail(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return allUsers.firstWhere((user) => user.id == userId);
  }
}
