import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_case_skill/modules/addEditUser/views/add_edit_user_form_view.dart';
import 'package:test_case_skill/modules/home/views/home_view.dart';

import 'core/styles/app_theme.dart';
import 'modules/login/views/login_view.dart';

void main() async {
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
        '/add-user': (context) => const AddEditUserFormView(),
        '/add-edit-user': (context) => const AddEditUserFormView(),
      },
    );
  }
}
