import 'dart:async';
import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';
import 'package:provider/provider.dart';

class UserLoginRequestService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String emailOrUsername = '';
  String password = 'contrasenya';
  bool google = false;
  static UserLoginRequest userLoginRequest = UserLoginRequest.empty();
  User userForEdit = User.empty();
  // Add loading state variable
  bool isLoadingForgotPassword = false;

  signIn(Map<String, dynamic> data) async {
    try {
      final jsonData = await CommuniverseProvider.postJsonData(
          '${CommuniverseProvider.apiAuthRoutes}signin', data);
          print("Termino httpPet: $jsonData");
      userLoginRequest = UserLoginRequest.fromJson(json.decode(jsonData));
      CommuniverseProvider.apiKey =
          '${userLoginRequest.type} ${userLoginRequest.token}';
      print(CommuniverseProvider.apiKey);
      print("Logged User: ${userLoginRequest}");
      notifyListeners();
    } catch (error) {
      // Extraer el mensaje de error de la cadena de excepción
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  findUserById(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('user/${id}');
      userForEdit = User.fromJson(json.decode(jsonData));
      print("Este es el usuario encotrado por ID: $userForEdit");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  editUser(String id, Map<String, dynamic> data) async {
    try {
      final jsonData = await CommuniverseProvider.putJsonData(
          '${CommuniverseProvider.apiAuthRoutes}edit/$id', data);
      Map<String, dynamic> credentials = {
        "emailOrUsername": userLoginRequest.email,
        "password": password,
        "google": userLoginRequest.isGoogle
      };
      print("edit user $credentials");
      await signIn(credentials);
      notifyListeners();
    } catch (error) {
      // Extraer el mensaje de error de la cadena de excepción
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

    editUserCommunities(String id, Map<String, dynamic> data) async {
    try {
      final jsonData = await CommuniverseProvider.putJsonData(
          '${CommuniverseProvider.apiAuthRoutes}editUserCommunities/$id', data);
      Map<String, dynamic> credentials = {
        "emailOrUsername": userLoginRequest.email,
        "password": password,
        "google": userLoginRequest.isGoogle
      };
      print("edit user $credentials");
      await signIn(credentials);
      notifyListeners();
    } catch (error) {
      // Extraer el mensaje de error de la cadena de excepción
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

    editPhotoUser(String id, Map<String, dynamic> data) async {
    try {
      final jsonData = await CommuniverseProvider.putJsonData(
          '${CommuniverseProvider.apiAuthRoutes}editphoto/$id', data);
      Map<String, dynamic> credentials = {
        "emailOrUsername": userLoginRequest.email,
        "password": password,
        "google": userLoginRequest.isGoogle
      };
      print(credentials);
      await signIn(credentials);
      notifyListeners();
    } catch (error) {
      // Extraer el mensaje de error de la cadena de excepción
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  void clearData() {
    formKey = new GlobalKey<FormState>();
    emailOrUsername = '';
    password = 'contrasenya';
    userLoginRequest = UserLoginRequest.empty();
    userForEdit = User.empty();
    isLoadingForgotPassword = false;
  }

  Map<String, dynamic> toJson() => {
        "emailOrUsername": emailOrUsername,
        "password": password,
        "google": google
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
