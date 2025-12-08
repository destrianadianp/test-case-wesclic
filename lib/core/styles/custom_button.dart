import 'package:flutter/material.dart';
import 'package:test_case_skill/core/styles/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onpressed;
  final Color textColor;
  final Color backgroundColor;

  const CustomButton({
    required this.child, 
    this.onpressed,
    this.textColor = background, 
    this.backgroundColor = primaryBlue, 
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: textColor,),
              child: child,
          ),
        )
      ),
    );
  }
}