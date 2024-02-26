import 'dart:async';
import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class UserLoginRequestService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String emailOrUsername = '';
  String password = '';

  static UserLoginRequest userLoginRequest = UserLoginRequest.empty();

  // Add loading state variable
  bool isLoadingForgotPassword = false;

  signIn(Map<String, dynamic> data) async {
    try {
      final jsonData = await CommuniverseProvider.postJsonData(
          '${CommuniverseProvider.apiAuthRoutes}signin', data);
      userLoginRequest = UserLoginRequest.fromJson(json.decode(jsonData));
      CommuniverseProvider.apiKey =
          '${userLoginRequest.type} ${userLoginRequest.token}';
      print(CommuniverseProvider.apiKey);
      print("Logged User: $userLoginRequest");
      notifyListeners();
    } catch (error) {
      // Extraer el mensaje de error de la cadena de excepción
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  Map<String, dynamic> toJson() => {
        "emailOrUsername": emailOrUsername,
        "password": password,
      };

/*
  Future<String> forgotPassword(String email) async {
    isLoadingForgotPassword = true;
    notifyListeners();

    final response = await TransitaProvider.getJsonData('transita3/api/auth/forgot-password/$email');

    isLoadingForgotPassword = false;
    notifyListeners();

    if (response.contains('Internal Server Error')) {
      throw Exception('Error interno del servidor');
    }

    return response;
  }
*/
}
