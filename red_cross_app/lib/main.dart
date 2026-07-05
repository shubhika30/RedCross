import 'package:flutter/material.dart';
import 'screens/auth/user_login_screen.dart';

void main() {
  runApp(const RedCrossApp());
}

class RedCrossApp extends StatelessWidget {
  const RedCrossApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Red Cross",

      theme: ThemeData(
        primarySwatch: Colors.red,
      ),

      home: const UserLoginScreen(),
    );
  }
}