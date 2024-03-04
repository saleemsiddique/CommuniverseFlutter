import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class PostService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  List<Post> myPosts = [];
  Post post = Post.empty();

  findMyPosts(String id) async {
  try {
    final jsonData = await CommuniverseProvider.getJsonData('post/posts/${id}');
      final List<dynamic> jsonList = json.decode(jsonData);
      List<Post> newPosts =
          jsonList.map((json) => Post.fromJson(json)).toList();

      if (!listEquals(myPosts, newPosts)) {
        myPosts = newPosts;
        print("about to notify");
        notifyListeners();
      }
    notifyListeners();
  } catch (error) {
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}
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
