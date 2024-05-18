import 'dart:convert';


class User {
  String id;
  String name;
  String lastName;
  String email;
  String password;
  String username;
  String photo;
  String biography;
  UserStats userStats;
  List<String> createdCommunities;
  List<String> moderatedCommunities;
  List<String> memberCommunities;
  Interactions interactions;
  List<String> followersId;
  List<String> followedId;
  bool isGoogle;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.username,
    required this.photo,
    required this.biography,
    required this.userStats,
    required this.createdCommunities,
    required this.moderatedCommunities,
    required this.memberCommunities,
    required this.interactions,
    required this.followersId,
    required this.followedId,
    required this.isGoogle,
  });

  factory User.empty() {
    return User(
      id: '',
      name: '',
      lastName: '',
      email: '',
      password: '',
      username: '',
      photo: '',
      biography: '',
      userStats: UserStats(level: 0, totalPoints: 0),
      createdCommunities: [],
      moderatedCommunities: [],
      memberCommunities: [],
      interactions: Interactions(receivedLikes: 0, receivedReposts: 0),
      followersId: [],
      followedId: [],
      isGoogle: false,
    );
  }

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        photo: json["photo"],
        biography: json["biography"],
        userStats: UserStats.fromJson(json["userStats"]),
        createdCommunities: List<String>.from(json["createdCommunities"].map((x) => x)),
        moderatedCommunities: List<String>.from(json["moderatedCommunities"].map((x) => x)),
        memberCommunities: List<String>.from(json["memberCommunities"].map((x) => x)),
        interactions: Interactions.fromJson(json["interactions"]),
        followersId: List<String>.from(json["followers_id"].map((x) => x)),
        followedId: List<String>.from(json["followed_id"].map((x) => x)),
        isGoogle: json["google"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": password,
        "username": username,
        "photo": photo,
        "biography": biography,
        "userStats": userStats.toJson(),
        "createdCommunities": List<String>.from(createdCommunities.map((x) => x)),
        "moderatedCommunities": List<String>.from(moderatedCommunities.map((x) => x)),
        "memberCommunities": List<String>.from(memberCommunities.map((x) => x)),
        "interactions": interactions.toJson(),
        "followers_id": List<String>.from(followersId.map((x) => x)),
        "followed_id": List<String>.from(followedId.map((x) => x)),
        "isGoogle": isGoogle,
      };
  @override
  String toString() {
    return 'User{id: $id, name: $name, lastName: $lastName, email: $email, username: $username, createdCommunities: $createdCommunities}';
  }
}

class Interactions {
  int receivedLikes;
  int receivedReposts;

  Interactions({
    required this.receivedLikes,
    required this.receivedReposts,
  });

  factory Interactions.fromRawJson(String str) =>
      Interactions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Interactions.fromJson(Map<String, dynamic> json) => Interactions(
        receivedLikes: json["receivedLikes"],
        receivedReposts: json["receivedReposts"],
      );

  Map<String, dynamic> toJson() => {
        "receivedLikes": receivedLikes,
        "receivedReposts": receivedReposts,
      };
}

class UserStats {
  int level;
  int totalPoints;

  UserStats({
    required this.level,
    required this.totalPoints,
  });

  factory UserStats.fromRawJson(String str) =>
      UserStats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        level: json["level"],
        totalPoints: json["totalPoints"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "totalPoints": totalPoints,
      };
}
