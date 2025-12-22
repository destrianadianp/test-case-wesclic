import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_skill/modules/add_edit_user/view_models/add_edit_user_view_model.dart';

import '../../../core/styles/custom_button.dart';
import '../../../core/styles/custom_text_field.dart';

class AddEditUserFormView extends StatelessWidget {

  final String? userId;

  const AddEditUserFormView({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEditUserViewModel(userId: userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(userId == null ? 'Tambah User Baru' : 'Edit User'),
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
                            print('Tombol simpan perubahan ditekan!');
                            final newUser = await viewModel.submitForm();

                            if (context.mounted) {
                              if (newUser != null) {
                                Navigator.pop(context, newUser);
                              } else {
                                if (viewModel.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.errorMessage!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(userId == null ? 'Tambah User' : 'Simpan Perubahan'),
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