import 'dart:convert';

class Community {
    String id;
    String name;
    String userCreatorId;
    String description;
    String privacy;
    String photo;
    int followers;
    List<dynamic>? postsId;

    String? uniqueId;

    Community({
        required this.id,
        required this.name,
        required this.userCreatorId,
        required this.description,
        required this.privacy,
        required this.photo,
        required this.followers,
        required this.postsId,
    });

    factory Community.fromRawJson(String str) => Community.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json["id"],
        name: json["name"],
        userCreatorId: json["userCreator_id"],
        description: json["description"],
        privacy: json["privacy"],
        photo: json["photo"],
        followers: json["followers"],
        postsId: json["posts_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userCreator_id": userCreatorId,
        "description": description,
        "privacy": privacy,
        "photo": photo,
        "followers": followers,
        "posts_id": postsId,
    };
}
