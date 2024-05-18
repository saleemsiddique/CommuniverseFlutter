import 'dart:convert';

class UserLoginRequest {
    String token;
    String type;
    String id;
    String name;
    String lastName;
    String email;
    String password;
    String username;
    bool isGoogle;

    UserLoginRequest({
        required this.token,
        required this.type,
        required this.id,
        required this.name,
        required this.lastName,
        required this.email,
        required this.password,
        required this.username,
        required this.isGoogle,
    });

    UserLoginRequest.empty()
        : token = '',
          type = '',
          id = '',
          name = '',
          lastName = '',
          email = '',
          password = '',
          username = '',
          isGoogle = false;

    factory UserLoginRequest.fromRawJson(String str) => UserLoginRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserLoginRequest.fromJson(Map<String, dynamic> json) => UserLoginRequest(
        token: json["token"],
        type: json["type"],
        id: json["id"],
        name: json["name"],
        lastName: json["lastname"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        isGoogle: json["google"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "type": type,
        "id": id,
        "name": name,
        "lastname": lastName,
        "email": email,
        "password": password,
        "username": username,
        "isGoogle": isGoogle,
    };
}
