
import '../../../core/models/user_model.dart';
import '../../../core/services/mock_data.dart';

class LoginMockService {
  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return allUsers.firstWhere((u) => u.name.toLowerCase() == username.toLowerCase()); 
    } catch (e) {
      return null;
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