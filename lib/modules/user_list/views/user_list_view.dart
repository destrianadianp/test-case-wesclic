import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/user_list_item.dart';
import '../view_models/user_list_view_model.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserListViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('All Users')),
        body: Consumer<UserListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.errorMessage != null) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.allUsers.length,
              itemBuilder: (context, index) {
                return UserListItem(user: viewModel.allUsers[index]);
              },
            );
          },
        ),
      ),
    );
  }
}