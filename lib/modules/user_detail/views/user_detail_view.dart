import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_skill/core/styles/app_colors.dart';
import 'package:test_case_skill/core/styles/custom_button.dart';

import '../../../core/models/user_model.dart';
import '../components/profile_header.dart';
import '../view_models/user_detail_view_model.dart';

class UserDetailView extends StatelessWidget {
  final String userId;
  final Function(UserModel)? onUserUpdated; // Callback to notify parent

  const UserDetailView({super.key, required this.userId, this.onUserUpdated});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailViewModel(userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Detail')),
        body: Consumer<UserDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.errorMessage != null) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }
            final user = viewModel.user;
            if (user == null) {
              return const Center(child: Text('Pengguna tidak ditemukan'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: ProfileHeader(user: user)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          child: Text(
                            "Edit",
                            style: TextStyle(color: background),
                          ),
                          onpressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/add-edit-user',
                              arguments: user.id,
                            );

                            // After editing, update the local data with the returned user
                            if (result != null && result is UserModel) {
                              viewModel.updateUserData(result);
                              // Notify parent that user was updated
                              if (onUserUpdated != null) {
                                onUserUpdated!(result);
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          child: Text("Hapus"),
                          onpressed: () async {
                            await viewModel.deleteUser(user.id);

                            if (context.mounted) {
                              Navigator.pop(context, user.id);
                            }
                          },
                        ),
                      ),
                    ],
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
