import 'dart:convert';
import 'dart:math';
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
  List<Post> communityPosts = [];
  List<Post> communityQuizzes = [];
  List<Post> communitymySpacePosts = [];

  int currentPostPage = 0;
  int currentRepostPage = 0;
  int currentCommentPage = 0;
  int currentCommunityPostPage = 0;
  int currentCommunityQuizzPage = 0;
  int currentMySpacePage = 0;
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
      print("Posts termino");
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
      print("Reposts termino");

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
      List<Post> newPosts =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

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

  Future<void> getAllPostsFromCommunity(String communityId) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/community/$communityId/$currentCommunityPostPage/$pageSize');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> postsFromCommunity =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Limpiar la lista si es la primera página
      if (currentCommunityPostPage == 0) {
        communityPosts.clear();
      }

      communityPosts.addAll(postsFromCommunity);
      currentCommunityPostPage++;

      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  Future<void> getAllQuizzFromCommunity(String communityId) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/community/$communityId/quizz/$currentCommunityQuizzPage/$pageSize');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> quizzFromCommunity =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Limpiar la lista si es la primera página
      if (currentCommunityQuizzPage == 0) {
        communityQuizzes.clear();
      }

      communityQuizzes.addAll(quizzFromCommunity);
      currentCommunityQuizzPage++;

      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  Future<void> getMySpaceFromCommunity(
      String communityId, List<String> followedList) async {
    String followed = followedList.isNotEmpty ? followedList.join(',') : "none";
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/community/$communityId/myspace/$followed/$currentMySpacePage/$pageSize');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      List<Post> quizzFromCommunity =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      print("Page $currentMySpacePage: $quizzFromCommunity");

      // Limpiar la lista si es la primera página
      if (currentMySpacePage == 0) {
        communitymySpacePosts.clear();
      }

      communitymySpacePosts.addAll(quizzFromCommunity);
      currentMySpacePage++;

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

  Future<void> postPost(Map<String, dynamic> data, String parentPostId) async {
    try {
      final jsonData =
          await CommuniverseProvider.postJsonData('post/${parentPostId}', data);
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  likeOrRepost(String action, String postId, String userId) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          'post/$action/$postId/$userId');
      Post postUpdated = Post.fromJson(json.decode(jsonData));
      print("Este es el post encotrado por ID: $postUpdated");
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to add like: $error');
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
