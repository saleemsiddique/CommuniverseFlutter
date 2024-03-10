import 'package:flutter/material.dart';
import 'package:communiverse/models/post.dart';
import 'package:communiverse/widgets/post_widget.dart';
import 'package:communiverse/services/post_service.dart';

class CommentsScreen extends StatelessWidget {
  final Post post;
  final PostService postService;

  const CommentsScreen({Key? key, required this.post, required this.postService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Post principal
          PostWidget(post: post),

          // Lista de comentarios
          Expanded(
            child: _buildCommentsList(post),
          ),
        ],
      ),
    );
  }

Widget _buildCommentsList(Post post) {
  return FutureBuilder<List<Post>>(
    future: postService.findMyCommentsPaged(post.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        final List<Post> comments = snapshot.data!;
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final Post comment = comments[index];
            return PostWidget(post: comment);
          },
        );
      }
    },
  );
}
}