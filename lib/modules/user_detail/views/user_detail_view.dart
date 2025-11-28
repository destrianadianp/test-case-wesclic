import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/profile_header.dart';
import '../view_models/user_detail_view_model.dart';

class UserDetailView extends StatelessWidget {
  final String userId;
  const UserDetailView({super.key, required this.userId});

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
              child: Center(
                child: ProfileHeader(user: user),
              ),
            );
          },
        ),
      ),
    );
  }
}