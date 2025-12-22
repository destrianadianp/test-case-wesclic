import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../services/user_list_api_service.dart';

class UserListViewModel extends ChangeNotifier {
  final UserListApiService _apiService = UserListApiService();
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