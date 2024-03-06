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

    getMyCommunities(String id) async {
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

}
