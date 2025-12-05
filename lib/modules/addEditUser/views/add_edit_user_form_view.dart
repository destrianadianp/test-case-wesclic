import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_skill/core/models/user_model.dart';
import 'package:test_case_skill/modules/addEditUser/view_model/add_edit_user_view_model.dart';

import '../../../core/styles/custom_button.dart';
import '../../../core/styles/custom_text_field.dart';

class AddEditUserFormView extends StatelessWidget {
  
  final UserModel? userToEdit;

  const AddEditUserFormView({super.key, this.userToEdit});

  @override
 Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEditUserViewModel(userToEdit: userToEdit),
      child: Scaffold(
        appBar: AppBar(
          title: Text(userToEdit == null ? 'Tambah User Baru' : 'Edit User'),
        ),
        body: Consumer<AddEditUserViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama',
                    controller: viewModel.nameController,
                    text: 'Masukkan Nama Lengkap',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Pekerjaan (Job)',
                    controller: viewModel.jobController,
                    text: 'Masukkan Jabatan/Pekerjaan',
                  ),
                  const SizedBox(height: 30),
                  
                  CustomButton(
                    onpressed: viewModel.isLoading
                        ? null
                        : () async {
                            final newUser = await viewModel.submitForm();
                                Navigator.pop(context, newUser); 
                            // }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(userToEdit == null ? 'Tambah User' : 'Simpan Perubahan'),
                  ),
                  
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(
                            color: viewModel.errorMessage!.startsWith('Gagal:') ? Colors.red : Colors.green),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}