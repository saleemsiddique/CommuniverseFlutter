import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class UserService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String name = '';
  String lastName = '';
  String email = '';
  String password = '';
  String username = "";
  User user = new User.empty();

signUp(Map<String, dynamic> data) async {
  try {
    final jsonData = await CommuniverseProvider.postJsonData(
        '${CommuniverseProvider.apiAuthRoutes}signup', data);
    user = User.fromJson(json.decode(jsonData));
    print("Este es el usuario creado: $user");
    notifyListeners();
  } catch (error) {
    // Extraer el mensaje de error de la cadena de excepción
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": password,
        "username": username,
      };
}
