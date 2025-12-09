import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/user_model.dart';
import 'package:http/http.dart' as http;

class LoginApiService {
  Future<UserModel?> login(String email, String password) async {
    print('Attempting login with email: $email');
    final url = Uri.parse('https://reqres.in/api/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      print('Received token: $token');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print('Token saved to SharedPreferences');

      return UserModel.fromLoginResponse(email, token);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      print('Login failed with error: ${data['error'] ?? 'Kredensial tidak valid.'}');
      throw Exception(data['error'] ?? 'Kredensial tidak valid.');
    } else {
      print('Login failed with status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }
}
