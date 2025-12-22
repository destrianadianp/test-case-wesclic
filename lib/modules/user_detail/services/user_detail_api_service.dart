import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/models/user_model.dart';
import '../../../core/services/api_header.dart';

class UserDetailApiService {
  Future<UserModel> getUserDetail(String userId) async {
    print('Attempting to fetch user detail for ID: $userId');
    final url = Uri.parse('https://reqres.in/api/users/$userId');
    final response = await http.get(
      url,
      headers: ApiHeader.headers,
    );
    print('Get user detail response status: ${response.statusCode}');
    print('Get user detail response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userData = data['data'];
      print('Successfully fetched user detail for ID: $userId');
      return UserModel(
        id: userData['id'].toString(),
        name: '${userData['first_name']} ${userData['last_name']}',
        email: userData['email'],
        imageUrl: userData['avatar'],
        job: userData['job'],
      );
    } else {
      print('Get user detail failed for ID: $userId with status code: ${response.statusCode}');
      throw Exception('Gagal menghubungi server. Kode: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(String userId) async {
    print('Attempting to delete user with ID: $userId');
    final url = Uri.parse('https://reqres.in/api/users/$userId');
    final response = await http.delete(
      url,
      headers: ApiHeader.headers,
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