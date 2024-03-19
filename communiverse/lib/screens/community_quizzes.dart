import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityQuizzes extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function() buildProgressIndicator;

  CommunityQuizzes({
    required this.scrollController,
    required this.buildProgressIndicator,
  });

  @override
  _CommunityQuizzesState createState() => _CommunityQuizzesState();
}

class _CommunityQuizzesState extends State<CommunityQuizzes> {
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
              itemCount: postService.communityQuizzes.length + 1,
              itemBuilder: (context, index) {
                if (index < postService.communityQuizzes.length) {
                  final post = postService.communityQuizzes[index];
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
