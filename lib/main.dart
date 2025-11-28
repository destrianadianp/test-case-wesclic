import 'package:flutter/material.dart';

import 'core/styles/app_theme.dart';
import 'modules/login/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Case',
      theme: appTheme,
      home: const LoginView(),
    );
  }
}
