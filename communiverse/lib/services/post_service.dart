import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class PostService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Post post = Post.empty();

  findPostById(String id) async {
  try {
    final jsonData = await CommuniverseProvider.getJsonData('post/${id}');
    post = Post.fromJson(json.decode(jsonData));
    print("Este es el post encotrado por ID: $post");
    notifyListeners();
  } catch (error) {
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}

  Future<User> findPostAuthor(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('user/${id}');
      User user = User.fromJson(json.decode(jsonData));
      print("Este es el usuario del post: $user");
      return user;
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

    Future<Community> findPostCommunity(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData('community/${id}');
      Community community = Community.fromJson(json.decode(jsonData));
      print("Este es el community del post: $community");
      return community;
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }
}
