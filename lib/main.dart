import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_case_skill/modules/add_edit_user/views/add_edit_user_form_view.dart';
import 'package:test_case_skill/modules/home/views/home_view.dart';

import 'core/styles/app_theme.dart';
import 'modules/login/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final saveToken = prefs.getString('token');

  final initialRoute = saveToken == null ? 'Login' : 'Home';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Case',
      theme: appTheme,
      initialRoute: initialRoute,
      routes: {
        'Login': (context) => const LoginView(),
        'Home': (context) => const HomeView(),
        '/add-user': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          log('Navigating to /add-user with userId: $userId');
          return AddEditUserFormView(userId: userId);
        },
        '/add-edit-user': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          log('Navigating to /add-edit-user with userId: $userId');
          return AddEditUserFormView(userId: userId);
        },
      },
    );
  }
}
