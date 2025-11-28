import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/login/services/login_mock_service.dart';

import '../../../core/models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginMockService _apiService = LoginMockService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<UserModel?> attemptLogin(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);
      if (user != null) {
        return user;
      } else {
        _errorMessage = 'Login Gagal: Nama pengguna tidak ditemukan atau password salah.';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}