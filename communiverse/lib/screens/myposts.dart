import 'package:communiverse/services/post_service.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPosts extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function() buildProgressIndicator;

  MyPosts({
    required this.scrollController,
    required this.buildProgressIndicator,
  });

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);    
    return Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: widget.scrollController,
                    itemCount: postService.myPosts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < postService.myPosts.length) {
                        final post = postService.myPosts[index];
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
  
}