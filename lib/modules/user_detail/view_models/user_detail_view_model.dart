import 'package:flutter/material.dart';
import 'package:test_case_skill/core/database/database_helper.dart';
import 'package:test_case_skill/modules/user_detail/services/user_detail_api_service.dart';

import '../../../core/models/user_model.dart';

class UserDetailViewModel extends ChangeNotifier {
  final UserDetailApiService _apiService = UserDetailApiService();

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

  Future<void> refreshUser() async {
    if (_user != null) {
      fetchUserDetail(_user!.id);
    }
  }

  Future<void> deleteUser(String userId) async {
    await _apiService.deleteUser(userId);
    await DatabaseHelper().deteleUser(userId);
  }

  // Method to update the local user data
  void updateUserData(UserModel updatedUser) {
    if (_user != null && _user!.id == updatedUser.id) {
      _user = updatedUser;
      notifyListeners();
    }
  }
}