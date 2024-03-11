import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReposts extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function() buildProgressIndicator;

  MyReposts({required this.scrollController,
      required this.buildProgressIndicator,
});

  @override
  _MyRepostsState createState() => _MyRepostsState();
}

class _MyRepostsState extends State<MyReposts> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: postService.myRePosts.length + 1,
              itemBuilder: (context, index) {
                if (index < postService.myRePosts.length) {
                  final post = postService.myRePosts[index];
                  return PostWidget(post: post, isExtend: false);
                } else {
                  return widget.buildProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  // Métodos noPosts y _buildProgressIndicator omitidos por brevedad
}
