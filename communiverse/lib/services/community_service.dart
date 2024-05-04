import 'dart:convert';

import 'package:communiverse/provider/provider_communiverse.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class CommunityService extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  List<Community> top5Communities = [];
  List<Community> myCommunities = [];
  Community createdCommunity = Community.empty();
  Community chosenCommunity = Community.empty();
  List<User> bannedUsers = [];
  List<Community> searchedCommunityList = [];

  getTop5Communities() async {
    final userLoginRequestService = UserLoginRequestService.userLoginRequest;
    CommuniverseProvider.apiKey = '${userLoginRequestService.type} ${userLoginRequestService.token}';
    if (userLoginRequestService != null) {
      final jsonData = await CommuniverseProvider.getJsonData(
          '/community/top5');
      final List<dynamic> jsonList = json.decode(jsonData);
      List<Community> newTop5 =
          jsonList.map((json) => Community.fromJson(json)).toList();

      if (!listEquals(top5Communities, newTop5)) {
        top5Communities = newTop5;
        print("about to notify");
        notifyListeners();
      }
    }
  }

    Future<void>getMyCommunities(String id) async {
    final userLoginRequestService = UserLoginRequestService.userLoginRequest;
    CommuniverseProvider.apiKey = '${userLoginRequestService.type} ${userLoginRequestService.token}';
    if (userLoginRequestService != null) {
      final jsonData = await CommuniverseProvider.getJsonData(
          '/community/mycommunities/${id}');
      final List<dynamic> jsonList = json.decode(jsonData);
      List<Community> newMyCommunities =
          jsonList.map((json) => Community.fromJson(json)).toList();

      if (!listEquals(myCommunities, newMyCommunities)) {
        myCommunities = newMyCommunities;
        print("about to notify");
        notifyListeners();
      }
    }
  }

    searchCommunityList(String name) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          '/community/nameRegex/${name}');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      searchedCommunityList =
          jsonResponse.map((json) => Community.fromJson(json)).toList();
      print("Comunidades encontrados $searchedCommunityList");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

Future<void> postCommunity(Map<String, dynamic> data) async {
  try {
    final jsonData = await CommuniverseProvider.postJsonData('community', data);
    final createdCommunityJson = json.decode(jsonData);
    createdCommunity = Community.fromJson(createdCommunityJson);
    notifyListeners();
  } catch (error) {
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}

Future<void> editCommunity(String id, Map<String, dynamic> data) async {
  try {
    final jsonData = await CommuniverseProvider.putJsonData('community/$id', data);
    final editedCommunityJson = json.decode(jsonData);
    chosenCommunity = Community.fromJson(editedCommunityJson);
    notifyListeners();
  } catch (error) {
    String errorMessage = error.toString().replaceAll('Exception: ', '');
    throw errorMessage;
  }
}

  searchCommunityBannedUsersList(String communityId) async {
    try {
      final jsonData = await CommuniverseProvider.getJsonData(
          '/community/$communityId/banned');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      bannedUsers =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      print("Usuarios encontrados $bannedUsers");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

    unbanUser(String communityId, String userId) async {
    try {
      final jsonData = await CommuniverseProvider.deleteJsonData(
          '/community/$communityId/banned/$userId');
      final List<dynamic> jsonResponse = json.decode(jsonData);
      bannedUsers =
          jsonResponse.map((json) => User.fromJson(json)).toList();
      print("Usuarios encontrados $bannedUsers");
      notifyListeners();
    } catch (error) {
      String errorMessage = error.toString().replaceAll('Exception: ', '');
      throw errorMessage;
    }
  }

  void clearData() {
    formKey = new GlobalKey<FormState>();
    top5Communities.clear();
    myCommunities.clear();
  }

}
