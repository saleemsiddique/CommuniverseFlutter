import 'dart:convert';

class User {
    String id;
    String name;
    String lastName;
    String email;
    String password;
    String username;
    String biography;
    int level;
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
        required this.level,
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
      level = 0,
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
        level: json["level"],
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
        "level": level,
        "createdCommunities": List<dynamic>.from(createdCommunities.map((x) => x)),
        "moderatedCommunities": List<dynamic>.from(moderatedCommunities.map((x) => x)),
        "memberCommunities": List<dynamic>.from(memberCommunities.map((x) => x)),
        "interactions": interactions.toJson(),
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

    factory UserInteractions.fromRawJson(String str) => UserInteractions.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserInteractions.fromJson(Map<String, dynamic> json) => UserInteractions(
        receivedLikes: json["receivedLikes"],
        receivedReposts: json["receivedReposts"],
    );

    Map<String, dynamic> toJson() => {
        "receivedLikes": receivedLikes,
        "receivedReposts": receivedReposts,
    };
}
