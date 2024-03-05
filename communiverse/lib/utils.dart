import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:flutter/material.dart';

class Utils {
  static void openImageInFullScreen(BuildContext context, String imageUrl, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl, post: post,),
      ),
    );
  }

  static void openVideoInFullScreen(BuildContext context, String videoUrl, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenVideo(videoUrl: videoUrl, post: post),
    ),
  );
}
}
