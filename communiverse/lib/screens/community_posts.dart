import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityPosts extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function() buildProgressIndicator;

  CommunityPosts({
    required this.scrollController,
    required this.buildProgressIndicator,
  });

  @override
  _CommunityPostsState createState() => _CommunityPostsState();
}

class _CommunityPostsState extends State<CommunityPosts> {
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
              itemCount: postService.communityPosts.length + 1,
              itemBuilder: (context, index) {
                if (index < postService.communityPosts.length) {
                  final post = postService.communityPosts[index];
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
