import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final Post post;

  const FullScreenImage({Key? key, required this.imageUrl, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
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
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInteractionIconButton(
                    Icons.favorite_border, post.postInteractions.likes),
                _buildInteractionIconButton(
                    Icons.comment, post.postInteractions.comments.length),
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
