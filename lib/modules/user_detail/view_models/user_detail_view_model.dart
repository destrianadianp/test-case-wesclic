import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/login/services/login_mock_service.dart';

import '../../../core/models/user_model.dart';

class UserDetailViewModel extends ChangeNotifier {
  Future <void> DeleteUser(String userId) async {
    await _apiService.DeleteUser(userId);
  }
  final LoginMockService _apiService = LoginMockService();
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserDetailViewModel(String userId) {
    fetchUserDetail(userId);
  }

  Future<void> fetchUserDetail(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _apiService.getUserDetail(userId);
    } catch (e) {
      _errorMessage = 'Gagal memuat detail pengguna.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}