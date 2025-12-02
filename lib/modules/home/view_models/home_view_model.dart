import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/login/services/login_mock_service.dart';

import '../../../core/models/user_model.dart';

class HomeViewModel extends ChangeNotifier {//
  final LoginMockService _apiService = LoginMockService();
  List<UserModel> _topUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<UserModel> get topUsers => _topUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeViewModel() {
    fetchTopUsers();
  }

  Future<void> fetchTopUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _topUsers = await _apiService.getTopUsers();
    } catch (e) {
      _errorMessage = 'Gagal memuat pengguna teratas.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}