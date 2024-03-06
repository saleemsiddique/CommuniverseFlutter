import 'dart:convert';
import 'package:communiverse/extras/pager.dart';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class PostService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Post post = Post.empty();
  List<Post> myPosts = [];
  List<Post> myRePosts = [];
  int currentPostPage = 0;
  int currentRepostPage = 0;
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
      final dynamic jsonResponse = json.decode(jsonData);
      final PostPage newPosts = PostPage.fromJson(jsonResponse);

      // Limpiar la lista si es la primera página
      if (currentPostPage == 0) {
        myPosts.clear();
      }

      myPosts.addAll(newPosts.posts);
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
      final dynamic jsonResponse = json.decode(jsonData);
      final PostPage newRePosts = PostPage.fromJson(jsonResponse);

      // Limpiar la lista si es la primera página
      if (currentRepostPage == 0) {
        myRePosts.clear();
      }

      myRePosts.addAll(newRePosts.posts);
      currentRepostPage++;

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
}
