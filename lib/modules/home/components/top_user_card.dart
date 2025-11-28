import 'package:flutter/material.dart';

import '../../../core/models/user_model.dart';
import '../../../core/styles/app_colors.dart';

class TopUserCard extends StatelessWidget {
  final UserModel user;
  final int rank;
  final VoidCallback onTap;

  const TopUserCard({super.key, required this.user, required this.rank, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: accentPurple,
          child: Text(
            '$rank',
            style: const TextStyle(color:accentPurple, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600, color: textDark)),
        subtitle: Text(user.email, style: const TextStyle(color: textLight)),
      ),
    );
  }
}