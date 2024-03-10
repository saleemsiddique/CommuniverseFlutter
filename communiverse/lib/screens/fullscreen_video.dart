import 'package:communiverse/models/models.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FullScreenVideo extends StatelessWidget {
  final String videoUrl;
  final Post post;

  const FullScreenVideo({Key? key, required this.videoUrl, required this.post})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: VideoPlayerWidget(videoUrl: videoUrl),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInteractionIconButton(
                    Icons.favorite_border, post.postInteractions.likes),
                _buildInteractionIconButton(
                    Icons.comment, post.postInteractions.commentsId.length),
                _buildInteractionIconButton(
                    Icons.repeat, post.postInteractions.reposts),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionIconButton(IconData icon, int count) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            // Acción correspondiente
          },
        ),
        Text(
          count.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
