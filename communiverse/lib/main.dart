import 'package:communiverse/routes/routes.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserLoginRequestService(),
          ),
          ChangeNotifierProvider.value(
            value: UserService(),
          ),
          ChangeNotifierProvider.value(
            value: CommunityService(),
          )
        ],
        child: MaterialApp(
          title: 'Communiverse',
          theme: ThemeData(
            fontFamily: 'WorkSans', // Registering the font family
          ),
          darkTheme: ThemeData(
            fontFamily: 'WorkSans', // Registering the font family
            scaffoldBackgroundColor: Color.fromRGBO(46, 30, 47, 1),
            primaryColor: Color.fromRGBO(106, 13, 173, 1),
          ),
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          routes: getApplicationRoutes(),
          initialRoute: "/",
        ));
  }
}
