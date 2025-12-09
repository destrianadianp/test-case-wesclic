import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/login/services/login_api_service.dart';

import '../../../core/models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginApiService _apiService = LoginApiService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<UserModel?> attemptLogin(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);
      return user;
    } 
    catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}