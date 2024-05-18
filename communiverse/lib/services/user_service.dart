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
  bool isGoogle = false;
  User user = new User.empty();
  User searchedUser = new User.empty();
  List<User> searchedUsersList = [];
  List<User> searchedCommunityUsersList = [];

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

  findUserById(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('user/${id}');
      user = User.fromJson(json.decode(jsonData));
      print("Este es el usuario encotrado por ID: $user");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

    findOtherUserById(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('user/${id}');
      searchedUser = User.fromJson(json.decode(jsonData));
      print("Este es el usuario encotrado por ID: $searchedUser");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  searchOtherUsers(String username) async {
    try {
      final jsonData =
          await CommuniverseProvider.getJsonData('user/username/${username}');
      searchedUser = User.fromJson(json.decode(jsonData));
      print("Este es el usuario encotrado por ID: $user");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  searchUsersList(String username) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/usernameRegex/${username}');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedUsersList =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      print("Usuarios encontrados $searchedUsersList");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  Future<User> findById(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('user/${id}');
      User user = User.fromJson(json.decode(jsonData));
      print("Este es el usuario encontrado por ID: $user");
      return user;
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  follow(String idFollowing, String idFollowed) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/follow/${idFollowing}/${idFollowed}');
      searchedUser = User.fromJson(json.decode(jsonData));
      print('$idFollowing has started following $idFollowed');
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  joinCommunity(String idCommunity, String idUser) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/join/${idCommunity}/${idUser}');
      user = User.fromJson(json.decode(jsonData));
      print('$idUser has joined community $idCommunity');
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  searchCommunityUsersList(String communityId) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/community/$communityId/members');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedCommunityUsersList =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      print("Usuarios encontrados $searchedCommunityUsersList");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  kickFromCommunity(String idCommunity, String idUser, int dias) async {
    try {
      final jsonData = await CommuniverseProvider.deleteJsonData(
          'user/$idUser/community/$idCommunity/$dias');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedCommunityUsersList =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  promoteInCommunity(String idCommunity, String idUser, String idCreator) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/$idCreator/$idUser/community/$idCommunity/promote');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedCommunityUsersList =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  demoteInCommunity(String idCommunity, String idUser) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'user/$idUser/community/$idCommunity/demote');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedCommunityUsersList =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  deleteCommunity(String id) async {
  try {
    final jsonData = await CommuniverseProvider.deleteJsonData('community/$id');
     user = User.fromJson(json.decode(jsonData));
    notifyListeners();
  } catch (error) {
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}

  void clearData() {
    formKey = new GlobalKey<FormState>();
    name = '';
    lastName = '';
    email = '';
    password = '';
    username = '';
    user = User.empty();
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": password,
        "username": username,
        "isGoogle": isGoogle
      };
}
