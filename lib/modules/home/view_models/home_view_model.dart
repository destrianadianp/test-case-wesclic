import 'package:flutter/material.dart';
import 'package:test_case_skill/modules/home/services/home_api_service.dart';
import 'package:test_case_skill/modules/login/services/login_api_service.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/models/user_model.dart';

class HomeViewModel extends ChangeNotifier {//
final HomeApiService _apiService = HomeApiService();
final DatabaseHelper _dbHelper = DatabaseHelper();

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
      // First, try to get top users from local database
      List<UserModel> localData = await _dbHelper.fetchTopUsers();

      if (localData.isNotEmpty) {
        // If we have local data, use the first 3 as top users
        _topUsers = localData.take(3).toList();
      } else {
        // If no local data, fetch from API
        _topUsers = await _apiService.getTopUsers();
      }
    } catch (e) {
      // If there's an error, try to get data from local database as fallback
      try {
        List<UserModel> localData = await _dbHelper.fetchTopUsers();
        _topUsers = localData.take(3).toList();
      } catch (localError) {
        _errorMessage = 'Gagal memuat pengguna teratas.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}