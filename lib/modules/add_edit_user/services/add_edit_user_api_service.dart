import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/models/user_model.dart';

class AddEditUserApiService {
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

        // Since we're only updating name and job via the API, return a UserModel with the updated values
        // but preserve the original id, email and imageUrl that don't change during name/job updates
        final result = UserModel(
          id: userId,  // Use the original userId
          name: name,  // Use the updated name
          email: 'placeholder@reqres.in', // This should be replaced with actual email from the original user
          imageUrl: 'https://i.pravatar.cc/150?img=default', // This should be replaced with original image
          job: job,    // Use the updated job
        );

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
}