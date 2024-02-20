import 'package:communiverse/screens/login_screen.dart';
import 'package:communiverse/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
    int _selectedIndex = 0;
  final screens = [
    LoginScreen(),
    SignupScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}