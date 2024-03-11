import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class PostService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Post post = Post.empty();
  List<Post> myPosts = [];
  List<Post> myRePosts = [];
  List<Post> comments = [];
  int currentPostPage = 0;
  int currentRepostPage = 0;
  int currentCommentPage = 0;
  int pageSize = 5;

  /*findMyPosts(String id) async {
    try {
      final jsonData =
          await CommuniverseProvider.getJsonData('post/posts/${id}');
      final List<dynamic> jsonList = json.decode(jsonData);
      List<Post> newPosts =
          jsonList.map((json) => Post.fromJson(json)).toList();

      if (!listEquals(myPosts, newPosts)) {
        myPosts = newPosts;
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }*/

  findMyPostsPaged(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/posts/$id/$currentPostPage/$pageSize');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> newPosts =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Limpiar la lista si es la primera página
      if (currentPostPage == 0) {
        myPosts.clear();
      }

      myPosts.addAll(newPosts);
      currentPostPage++;

      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  findMyRePostsPaged(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/reposts/$id/$currentRepostPage/$pageSize');
          print(jsonData);
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> newRePosts =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Limpiar la lista si es la primera página
      if (currentRepostPage == 0) {
        myRePosts.clear();
      }

      myRePosts.addAll(newRePosts);
      currentRepostPage++;

      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  findMyCommentsPaged(String id) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/comments/$id/$currentCommentPage/$pageSize');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> newPosts = jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Limpiar la lista si es la primera página
      if (currentCommentPage == 0) {
        comments.clear();
      }

      comments.addAll(newPosts);
      currentCommentPage++;

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

  Future<User> findRePostAuthor(String id) async {
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
      final jsonData =
          await CommuniverseProvider.getJsonData('community/${id}');
      Community community = Community.fromJson(json.decode(jsonData));
      print("Este es el community del post: $community");
      return community;
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  void clearData() {
    formKey = new GlobalKey<FormState>();
    myPosts.clear();
    myRePosts.clear();
    comments.clear();
    currentPostPage = 0;
    currentRepostPage = 0;
  }
}
