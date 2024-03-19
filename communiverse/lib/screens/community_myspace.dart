import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityMySpace extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function() buildProgressIndicator;

  CommunityMySpace({
    required this.scrollController,
    required this.buildProgressIndicator,
  });

  @override
  _CommunityMySpaceState createState() => _CommunityMySpaceState();
}

class _CommunityMySpaceState extends State<CommunityMySpace> {
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
              itemCount: postService.communitymySpacePosts.length + 1,
              itemBuilder: (context, index) {
                if (index < postService.communitymySpacePosts.length) {
                  final post = postService.communitymySpacePosts[index];
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
