// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:test_case_skill/core/models/user_model.dart';
import 'package:test_case_skill/modules/add_edit_user/services/add_edit_user_api_service.dart';
import 'package:test_case_skill/modules/user_detail/models/user_detail_api_service.dart';

class AddEditUserViewModel extends ChangeNotifier {
  final AddEditUserApiService _apiService = AddEditUserApiService();
  final UserDetailApiService _detailApiService = UserDetailApiService();

  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  UserModel? _editingUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _editingUser != null;

  AddEditUserViewModel({String? userId}){
    print('AddEditUserViewModel created with userId: $userId');
    if (userId != null) {
      _loadUserForEdit(userId);
    }
  }

  Future<void> _loadUserForEdit(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _detailApiService.getUserDetail(userId);
      _editingUser = user;
      nameController.text = _editingUser!.name;
      jobController.text = _editingUser!.job ?? '';
      print('User loaded for editing: ${_editingUser!.name} - ${_editingUser!.job}');
    } catch (e, stack) {
      _errorMessage = 'Gagal memuat data user: $e';
      print('Error loading user for edit: $e');
      print('Stack trace: $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<UserModel?> submitForm() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final name = nameController.text.trim();
    final job = jobController.text.trim();

    print('submitForm: Starting form submission - Name: $name, Job: $job, Editing: ${_editingUser != null}');

    if (name.isEmpty || job.isEmpty) {
        _errorMessage = "Nama dan Jabatan harus diisi.";
        print('submitForm: Validation failed - name or job is empty');
        _isLoading = false;
        notifyListeners();
        return null;
    }

    try {
      if (_editingUser != null) {
        //edit
        print('submitForm: EDITING - Attempting to update user ${_editingUser!.id} with name: $name, job: $job');
        final result = await _apiService.editUser(name, job, _editingUser!.id);
        if (result != null) {
          print('submitForm: SUCCESS - User updated successfully! Name: ${result.name}, Job: ${result.job}');
        } else {
          print('submitForm: editUser returned null - update may have failed');
        }
        return result;
      } else {
        // tambah
        print('submitForm: Creating new user with name: $name, job: $job');
        final result = await _apiService.createUser(name: name, job: job);
        print('submitForm: User creation completed');
        return result;
      }
    } catch (e, stack) {
      _errorMessage = 'Gagal: $e';
      print('submitForm: ERROR - Exception caught during form submission');
      print('submitForm: Error message: $e');
      print('submitForm: Stack trace: $stack');
      return null;
    } finally {
      print('submitForm: Setting loading state to false');
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    super.dispose();
  }
}