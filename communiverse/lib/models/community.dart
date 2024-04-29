import 'dart:convert';

import 'package:communiverse/models/post.dart';

import 'dart:convert';

class Community {
  String id;
  String name;
  String userCreatorId;
  String description;
  String photo;
  int followers;
  List<String>? postsId;
  List<BannedUser>? banned;

  String? uniqueId;

  Community({
    required this.id,
    required this.name,
    required this.userCreatorId,
    required this.description,
    required this.photo,
    required this.followers,
    required this.postsId,
    this.banned,
  });

  Community.empty()
      : id = '',
        name = '',
        userCreatorId = '',
        description = '',
        photo = '',
        followers = 0,
        postsId = [],
        banned = [],
        uniqueId = null;

  factory Community.fromRawJson(String str) =>
      Community.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json["id"],
        name: json["name"],
        userCreatorId: json["userCreator_id"],
        description: json["description"],
        photo: json["photo"],
        followers: json["followers"],
        postsId: List<String>.from(json["posts_id"].map((x) => x)),
        banned: json["banned"] != null
            ? List<BannedUser>.from(
                json["banned"].map((x) => BannedUser.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userCreator_id": userCreatorId,
        "description": description,
        "photo": photo,
        "followers": followers,
        "posts_id": postsId,
        "banned": banned?.map((bannedUser) => bannedUser.toJson()).toList(),
      };
}

class BannedUser {
  String userId;
  String until;

  BannedUser({
    required this.userId,
    required this.until,
  });

  factory BannedUser.fromJson(Map<String, dynamic> json) => BannedUser(
        userId: json["user_id"],
        until: json["until"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "until": until,
      };
}
