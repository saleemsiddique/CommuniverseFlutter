import 'dart:convert';

class User {
  String id;
  String name;
  String lastName;
  String email;
  String password;
  String username;
  String biography;
  UserStats userStats; // Objeto que maneja los niveles y puntos del usuario
  List<dynamic> createdCommunities;
  List<dynamic> moderatedCommunities;
  List<dynamic> memberCommunities;
  UserInteractions interactions;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.username,
    required this.biography,
    required this.userStats, // Actualización para incluir el objeto de estadísticas del usuario
    required this.createdCommunities,
    required this.moderatedCommunities,
    required this.memberCommunities,
    required this.interactions,
  });

  User.empty()
      : id = "",
        name = '',
        lastName = '',
        email = '',
        password = '',
        username = '',
        biography = "",
        userStats = UserStats.empty(), // Inicializa los niveles y puntos del usuario
        createdCommunities = [],
        moderatedCommunities = [],
        memberCommunities = [],
        interactions = UserInteractions.empty();

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        biography: json["biography"],
        userStats: UserStats.fromJson(json["userStats"]), // Parsea el objeto de estadísticas del usuario
        createdCommunities: List<dynamic>.from(json["createdCommunities"].map((x) => x)),
        moderatedCommunities: List<dynamic>.from(json["moderatedCommunities"].map((x) => x)),
        memberCommunities: List<dynamic>.from(json["memberCommunities"].map((x) => x)),
        interactions: UserInteractions.fromJson(json["interactions"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": password,
        "username": username,
        "biography": biography,
        "userStats": userStats.toJson(), // Serializa el objeto de estadísticas del usuario
        "createdCommunities": List<dynamic>.from(createdCommunities.map((x) => x)),
        "moderatedCommunities": List<dynamic>.from(moderatedCommunities.map((x) => x)),
        "memberCommunities": List<dynamic>.from(memberCommunities.map((x) => x)),
        "interactions": interactions.toJson(),
      };
}

class UserStats {
  int level;
  int totalPoints;

  UserStats({
    required this.level,
    required this.totalPoints,
  });

  UserStats.empty()
      : level = 10, // Nivel inicial
        totalPoints = 0;

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        level: json["level"],
        totalPoints: json["totalPoints"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "totalPoints": totalPoints,
      };
}

class UserInteractions {
  int receivedLikes;
  int receivedReposts;

  UserInteractions({
    required this.receivedLikes,
    required this.receivedReposts,
  });

  UserInteractions.empty()
      : receivedLikes = 0,
        receivedReposts = 0;

  factory UserInteractions.fromJson(Map<String, dynamic> json) => UserInteractions(
        receivedLikes: json["receivedLikes"],
        receivedReposts: json["receivedReposts"],
      );

  Map<String, dynamic> toJson() => {
        "receivedLikes": receivedLikes,
        "receivedReposts": receivedReposts,
      };
}
