import 'package:flutter/material.dart';
import 'package:test_case_skill/core/database/database_helper.dart';
import 'package:test_case_skill/core/models/user_model.dart';
import 'package:test_case_skill/modules/add_edit_user/services/add_edit_user_api_service.dart';
import 'package:test_case_skill/modules/user_detail/services/user_detail_api_service.dart';

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
    ('AddEditUserViewModel created with userId: $userId');
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
      debugPrint('User loaded for editing: ${_editingUser!.name} - ${_editingUser!.job}');
    } catch (e, stack) {
      _errorMessage = 'Gagal memuat data user: $e';
      debugPrint('Error loading user for edit: $e');
      debugPrint('Stack trace: $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<UserModel?> submitForm() async {
    final dbHelper = DatabaseHelper();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final name = nameController.text.trim();
    final job = jobController.text.trim();

    debugPrint('submitForm: Starting form submission - Name: $name, Job: $job, Editing: ${_editingUser != null}');

    if (name.isEmpty || job.isEmpty) {
        _errorMessage = "Nama dan Jabatan harus diisi.";
        debugPrint('submitForm: Validation failed - name or job is empty');
        _isLoading = false;
        notifyListeners();
        return null;
    }

    try {
      if (_editingUser != null) {
        //edit
        debugPrint('submitForm: EDITING - Attempting to update user ${_editingUser!.id} with name: $name, job: $job');
        final result = await _apiService.editUser(name, job, _editingUser!.id);

        if (result != null) {
          // Preserve the original email and imageUrl when updating a user
          final updatedUser = UserModel(
            id: _editingUser!.id,
            name: name,
            email: _editingUser!.email,
            imageUrl: _editingUser!.imageUrl,
            job: job,
          );
          //simpan sqlite
          await dbHelper.updateUser(updatedUser);
          debugPrint('submitForm: SUCCESS - User updated successfully! Name: ${updatedUser.name}, Job: ${updatedUser.job}');
          return updatedUser;
        } else {
          debugPrint('submitForm: editUser returned null - update may have failed');
        }
        return result;
      } else {
        // tambah
        debugPrint('submitForm: Creating new user with name: $name, job: $job');
        final result = await _apiService.createUser(name: name, job: job);
        debugPrint('submitForm: User creation completed');
        //simpan sqlite
        await dbHelper.insertUser(result);
        return result;
      }
    } catch (e, stack) {
      _errorMessage = 'Gagal: $e';
      debugPrint('submitForm: ERROR - Exception caught during form subscription');
      debugPrint('submitForm: Error message: $e');
      debugPrint('submitForm: Stack trace: $stack');
      return null;
    } finally {
      debugPrint('submitForm: Setting loading state to false');
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