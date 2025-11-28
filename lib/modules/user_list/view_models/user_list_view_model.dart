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

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allUsers = await _apiService.getAllUsers();
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar pengguna.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}