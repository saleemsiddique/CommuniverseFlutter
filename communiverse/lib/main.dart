import 'package:communiverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: MaterialApp(
        title: 'Communiverse',
        darkTheme: ThemeData(
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routes: getApplicationRoutes(),
        initialRoute: "/",
      ),
    );
  }
}
