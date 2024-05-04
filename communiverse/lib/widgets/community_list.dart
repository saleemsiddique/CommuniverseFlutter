import 'package:flutter/material.dart';

class CommunityItem extends StatelessWidget {
  final String name;
  final String photo;
  final int followers;

  CommunityItem({
    required this.name,
    required this.photo,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: _buildCommunityImage(),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        'Followers: $followers',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCommunityImage() {
    if (photo.isNotEmpty) {
      return Image.network(
        photo,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/no-image.jpg',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        'assets/no-image.jpg',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
  }
}
