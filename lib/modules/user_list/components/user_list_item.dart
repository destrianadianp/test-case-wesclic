import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/models/user_model.dart';
import '../../user_detail/views/user_detail_view.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final Function(String) onDelete; // Callback specifically for deletion
  final Function(UserModel) onUserUpdated; // Callback for user updates

  const UserListItem({super.key, required this.user, required this.onDelete, required this.onUserUpdated});

  void _navigateToDetail(BuildContext context) async {
    log('Navigating to detail for user: ${user.name}, ID: ${user.id}');
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailView(
          userId: user.id,
          onUserUpdated: onUserUpdated, // Pass the callback to the detail view
        ),
      ),
    );

    if (result is String) {
      // Deletion result - pass the user ID to remove from list
      onDelete(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          onTap: () => _navigateToDetail(context),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.imageUrl),
            radius: 24,
          ),
          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}