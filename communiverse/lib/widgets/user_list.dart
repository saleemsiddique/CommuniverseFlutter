import 'package:flutter/material.dart';

class UserProfileItem extends StatelessWidget {
  final String profilePic;
  final String username;
  final String fullname;

  UserProfileItem(
      {required this.username,
      required this.profilePic,
      required this.fullname});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage(profilePic), // Asigna la imagen del perfil como avatar
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            fullname,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}