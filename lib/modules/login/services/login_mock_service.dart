import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/mock_data.dart';
import 'package:http/http.dart' as http;

class LoginMockService {
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
      print('Get all users failed with status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }

  Future<UserModel> getUserDetail(String userId) async {
    print('Attempting to fetch user detail for ID: $userId');
    final url = Uri.parse('https://reqres.in/api/users/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
    );
    print('Get user detail response status: ${response.statusCode}');
    print('Get user detail response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Successfully fetched user detail for ID: $userId');
      return UserModel.fromJson(data['data']);
    } else {
      print('Get user detail failed for ID: $userId with status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }

  Future<UserModel> createUser({String? name, String? job}) async {
    print('Attempting to create user with name: $name, job: $job');
    final url = Uri.parse('https://reqres.in/api/users');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
      body: jsonEncode({'name': name, 'job': job}),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Successfully created user: ${data['name']}, job: ${data['job']}, ID: ${data['id']}');
      return UserModel.fromCRUD(data, email: 'created.user@reqres.in');
    } else {
      print('Failed to create user. Status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server');
    }
  }

  Future<UserModel?> editUser(String name, String job, String userId) async {
    print('editUser service: Starting edit operation for user ID: $userId, new name: $name, new job: $job');

    try {
      final url = Uri.parse('https://reqres.in/api/users/$userId');
      print('editUser service: Making PUT request to: $url');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
        },
        body: jsonEncode({'name': name, 'job': job}),
      );

      print('editUser service: Request completed with status: ${response.statusCode}');
      print('editUser service: Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('editUser service: SUCCESS - User updated successfully! Name: ${data['name']}, Job: ${data['job']}, ID: ${data['id']}');
        final result = UserModel.fromCRUD(data, email: 'updated.user@reqres.in', id: userId);
        print('editUser service: Returning updated user model with name: ${result.name}, job: ${result.job}, id: ${result.id}');
        return result;
      } else {
        print('editUser service: Request failed with status: ${response.statusCode}');
        print('editUser service: Failure response body: ${response.body}');
        throw Exception('Gagal menghubungi server: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('editUser service: ERROR - Exception occurred during edit operation');
      print('editUser service: Error: $e');
      print('editUser service: Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    print('Attempting to delete user with ID: $userId');
    final url = Uri.parse('https://reqres.in/api/users/$userId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_10624e327e9040d296d958c229836b07',
      },
    );
    if (response.statusCode == 204) {
      print('Successfully deleted user with ID: $userId');
     return;
    } else {
      print('Failed to delete user with ID: $userId. Status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server');
    }
  }
}
