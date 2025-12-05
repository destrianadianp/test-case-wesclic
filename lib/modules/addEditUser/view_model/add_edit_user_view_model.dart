import 'package:flutter/material.dart';
import 'package:test_case_skill/core/models/user_model.dart';
import 'package:test_case_skill/modules/login/services/login_mock_service.dart';

class AddEditUserViewModel extends ChangeNotifier {
  final LoginMockService _userService = LoginMockService();

  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  UserModel? _editingUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AddEditUserViewModel({UserModel? userToEdit}){
    _editingUser = userToEdit;
    if (_editingUser != null) {
      nameController.text = _editingUser!.name;
      jobController.text = _editingUser!.job ?? '';
    } 
  }
  Future<UserModel?> submitForm() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final name = nameController.text.trim();
    final job = jobController.text.trim();
    
    if (name.isEmpty || job.isEmpty) {
        _errorMessage = "Nama dan Jabatan harus diisi.";
        _isLoading = false;
        notifyListeners();
        return null;
    }

    try {
      if (_editingUser != null) {
        //edit
        final result = await _userService.EditUser(name, job, _editingUser!.id);
        _errorMessage = "User ${name} berhasil diupdate.";
        return result;
      } else {
        // tambah
        final result = await _userService.CreateUser(name: name, job: job);
        return result;
      }
    } catch (e) {
      _errorMessage = 'Gagal: ${e.toString()}';
      return null;
    } finally {
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