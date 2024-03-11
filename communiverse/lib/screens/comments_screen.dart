import 'package:flutter/material.dart';
import 'package:communiverse/models/post.dart';
import 'package:communiverse/widgets/post_widget.dart';
import 'package:communiverse/services/post_service.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final PostService postService;

  const CommentsScreen(
      {Key? key, required this.post, required this.postService})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late ScrollController _scrollController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final postService = widget.postService;
    if (!_loading &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _loading = true;
      });
      postService.findMyCommentsPaged(widget.post.id).then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Principal post
                PostWidget(post: widget.post, isExtend: true),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                // Lista de comentarios
                Expanded(
                  child: _buildCommentsList(),
                ),
              ],
            )));
  }

  Widget _buildCommentsList() {
  final List<Post> comments = widget.postService.comments;

  // Verificar si la lista de comentarios está vacía
  if (comments.isEmpty && !_loading) {
    return Center(
      child: Text(
        'No comments',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  return ListView.builder(
    controller: _scrollController,
    itemCount: comments.length + (_loading ? 1 : 0),
    itemBuilder: (context, index) {
      if (index < comments.length) {
        final Post comment = comments[index];
        return PostWidget(post: comment, isExtend: false);
      } else {
        return CircularProgressIndicator(); // Indicador de carga al final de la lista
      }
    },
  );
}

}
