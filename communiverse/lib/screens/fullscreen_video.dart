import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;
  final Post post;

  const FullScreenVideo({Key? key, required this.videoUrl, required this.post})
      : super(key: key);

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late bool isLiked; // Declarar isLiked como una variable miembro
  late bool isReposted; // Declarar isLiked como una variable miembro

  @override
  void initState() {
    super.initState();
    final userService = Provider.of<UserService>(context, listen: false);
    isLiked =
        widget.post.postInteractions.likeUsersId.contains(userService.user.id);
    isReposted = widget.post.postInteractions.repostUsersId
        .contains(userService.user.id);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: true);
    final postService = Provider.of<PostService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);

    Color likeButtonColor = isLiked ? Colors.red : Colors.grey;
    Color repostButtonColor = isReposted ? Colors.blue : Colors.grey;

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
              child: VideoPlayerWidget(videoUrl: widget.videoUrl),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInteractionCount(
                  Icons.comment,
                  widget.post.postInteractions.commentsId.length,
                  Colors.grey,
                  false, // likedByCurrentUser: false
                  () async {
                    postService.currentCommentPage = 0;
                    await postService.findMyCommentsPaged(widget.post.id);
                    // Navegar a la pantalla de comentarios cuando se toque el post
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                            post: widget.post),
                      ),
                    );
                  },
                ),
                SizedBox(width: 5),
                _buildInteractionCount(
                  Icons.repeat,
                  widget.post.postInteractions.repostUsersId.length,
                  repostButtonColor,
                  isReposted, // likedByCurrentUser: isReposted
                  () async {
                    try {
                      if (isReposted) {
                        await postService.likeOrRepost("removeRepost",
                            widget.post.id, userService.user.id);
                        setState(() {
                          isReposted = !isReposted;
                          repostButtonColor = Colors.grey;
                          // Remover el ID del usuario de la lista
                          widget.post.postInteractions.repostUsersId
                              .remove(userService.user.id);
                        });
                      } else {
                        await postService.likeOrRepost(
                            "addRepost", widget.post.id, userService.user.id);
                        setState(() {
                          isReposted = !isReposted;
                          repostButtonColor = Colors.blue;
                          // Agregar el ID del usuario a la lista
                          widget.post.postInteractions.repostUsersId
                              .add(userService.user.id);
                        });
                      }
                    } catch (error) {
                      print('Error adding or removing repost: $error');
                    }
                  },
                ),
                SizedBox(width: 5),
                _buildInteractionCount(
                  Icons.favorite,
                  widget.post.postInteractions.likeUsersId.length,
                  likeButtonColor, // Cambiado según el estado de "me gusta"
                  isLiked, // likedByCurrentUser
                  () async {
                    try {
                      if (isLiked) {
                        await postService.likeOrRepost(
                            "removeLike", widget.post.id, userService.user.id);
                        setState(() {
                          isLiked = !isLiked;
                          likeButtonColor = Colors.grey;
                          // Remover el ID del usuario de la lista
                          widget.post.postInteractions.likeUsersId
                              .remove(userService.user.id);
                        });
                      } else {
                        await postService.likeOrRepost(
                            "addLike", widget.post.id, userService.user.id);
                        setState(() {
                          isLiked = !isLiked;
                          likeButtonColor = Colors.red;
                          // Agregar el ID del usuario a la lista
                          widget.post.postInteractions.likeUsersId
                              .add(userService.user.id);
                        });
                      }
                    } catch (error) {
                      print('Error adding or removing like: $error');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInteractionCount(
  IconData icon,
  int count,
  Color color,
  bool likedByCurrentUser,
  VoidCallback? onPressed,
) {
  return Row(
    children: [
      IconButton(
        icon: Icon(
          icon,
          size: 22,
          color: color,
        ),
        onPressed: onPressed,
      ),
      Text(
        '$count',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ],
  );
}
