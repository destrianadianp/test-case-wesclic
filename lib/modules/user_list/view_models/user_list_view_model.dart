import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/login/services/login_mock_service.dart';

import '../../../core/models/user_model.dart';

class UserListViewModel extends ChangeNotifier {
  final LoginMockService _apiService = LoginMockService();
  List<UserModel> _allUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<UserModel> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserListViewModel() {
    fetchAllUsers();
  }

  void addLocalUser(UserModel user) {
    _allUsers.insert(0, user);
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allUsers = await _apiService.getAllUsers();
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar pengguna. $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to remove a user locally (for deletion)
  void removeUser(String userId) {
    _allUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  // Method to update a user locally (for editing)
  void updateUser(UserModel updatedUser) {
    final index = _allUsers.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _allUsers[index] = updatedUser;
      notifyListeners();
    }
  }
}