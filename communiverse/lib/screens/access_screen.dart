import 'package:flutter/material.dart';
import 'package:communiverse/screens/login_screen.dart';
import 'package:communiverse/screens/signup_screen.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  _AccessScreenState createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: size.height * 0.2, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10), // Espacio entre los textos
                    Text(
                      'Login or Sign up to access your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(86, 73, 87, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 5),
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          LoginForm(),
                          SignupScreen()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}