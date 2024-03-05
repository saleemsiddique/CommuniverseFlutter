import 'dart:convert';
import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class PostService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  List<Post> myPosts = [];
  List<Post> myRePosts = [];
  Post post = Post.empty();

  findMyPosts(String id) async {
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
  }

    findMyRePosts(String id) async {
    try {
      final jsonData =
          await CommuniverseProvider.getJsonData('post/reposts/${id}');
      final List<dynamic> jsonList = json.decode(jsonData);
      List<Post> newRePosts =
          jsonList.map((json) => Post.fromJson(json)).toList();

      if (!listEquals(myPosts, newRePosts)) {
        myRePosts = newRePosts;
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

   /*
   Future<void> findMyRePosts(String id) async {
    if (isLoading || allDataLoaded) return;

    try {
      isLoading = true;
      final jsonData = await CommuniverseProvider.getJsonData('post/reposts/$id/$currentPage/10');
      final dynamic jsonResponse = json.decode(jsonData);
      final PostPage newRePosts = PostPage.fromJson(jsonResponse);

      if (newRePosts.posts.isNotEmpty) {
        myRePosts.posts.addAll(newRePosts.posts);
        currentPage++;
      } else {
        allDataLoaded = true;
      }
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  */

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
