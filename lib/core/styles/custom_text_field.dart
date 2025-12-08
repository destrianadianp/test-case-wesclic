import 'package:flutter/material.dart';
import 'package:test_case_skill/core/styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final String label;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.text
  });

  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text
        ),
      ),
    );
  }
}