import 'package:communiverse/navigation_bar.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => AccessScreen(),
    'home': (BuildContext context) => CustomBottomNavigationBar(),
    'settings': (BuildContext context) => SettingsScreen(),
    'create_post': (BuildContext context) => CreatePostScreen(),
  };
}
