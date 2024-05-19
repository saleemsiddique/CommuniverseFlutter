import 'dart:typed_data';

import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/post_service.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final bool isExtend;
  final bool isUserPage;
  const PostWidget(
      {Key? key,
      required this.post,
      required this.isExtend,
      required this.isUserPage})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool isLiked; // Declarar isLiked como una variable miembro
  late bool isReposted; // Declarar isLiked como una variable miembro

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    final Size size = MediaQuery.of(context).size;
    final userService = Provider.of<UserService>(context, listen: true);
    isLiked =
        widget.post.postInteractions.likeUsersId.contains(userService.user.id);
    isReposted = widget.post.postInteractions.repostUsersId
        .contains(userService.user.id);
    // Verificar si el post tiene media
    final bool hasMedia =
        widget.post.photos.isNotEmpty || widget.post.videos.isNotEmpty;

    // Definir la altura del Card
    double cardHeight = hasMedia ? size.height * 0.32 : size.height * 0.23;
    // Ajustar la altura del Card si está extendido
    if (widget.isExtend && widget.post.quizz == Quizz.empty()) {
      cardHeight *= 1.2; // Ajusta el factor según lo necesites
    }

    if (widget.isExtend && hasMedia) {
      cardHeight = 250; // Ajusta el factor según lo necesites
    }

    if (widget.post.quizz != Quizz.empty()) {
      cardHeight = size.height * 0.38; // Ajusta el factor según lo necesites
    }

    return GestureDetector(
      onTap: () async {
        postService.currentCommentPage = 0;
        postService.parentPost = widget.post;
        await postService.findPostById(widget.post.id);
        await postService.findMyCommentsPaged(widget.post.id);
        // Navegar a la pantalla de comentarios cuando se toque el post
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CommentsScreen(post: widget.post),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Stack(
          children: [
            SizedBox(
              height: cardHeight,
              child: Card(
                color: Color.fromRGBO(46, 30, 47, 1),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.post.quizz == Quizz.empty()) ...[
                              _buildHeader(context),
                              if (widget.post.content != '') _buildContent(),
                              SizedBox(height: 10),
                              if (hasMedia) _buildMedia(),
                            ] else ...[
                              _buildHeader(context),
                              SizedBox(height: 15),
                              _buildQuizz(context, widget.post),
                              SizedBox(height: 1.4),
                            ]
                          ],
                        ),
                      ),
                      _buildInteractions(context),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.post.authorId == userService.user.id &&
                widget.isUserPage == true)
              Positioned(
                top: 10,
                right: 0,
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'delete',
                        child:
                            Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    if (value == 'delete') {
                      postService.currentPostPage = 0;
                      postService.currentRepostPage = 0;
                      await postService.deletePostById(widget.post.id);
                      await postService.findMyPostsPaged(userService.user.id);
                      if (widget.post.isComment) {
                        print("parent post ${postService.parentPost.id}");
                        postService.currentCommentPage = 0;
                        await postService.findMyCommentsPaged(postService.parentPost.id);
                        postService.parentPost.postInteractions.commentsId.remove(widget.post.id);
                      }
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    // Almacenar los datos recuperados en variables locales
    final authorFuture = postService.findPostAuthor(widget.post.authorId);
    final communityFuture =
        postService.findPostCommunity(widget.post.communityId);
    final List<String> repostUserIds =
        widget.post.postInteractions.repostUsersId;

    // Ahora, para buscar un valor específico dentro de la lista, podrías hacer algo como esto:
    String? repostUserId;
    final int index =
        repostUserIds.indexWhere((id) => id == userService.user.id);
    if (index != -1) {
      repostUserId = repostUserIds[index];
    }

    Future<User>? repostUserFuture;
    if (repostUserId != null && repostUserId != '') {
      repostUserFuture = postService.findRePostAuthor(repostUserId);
    }

    return FutureBuilder<User>(
      future: authorFuture,
      builder: (context, snapshotUser) {
        if (snapshotUser.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshotUser.hasError) {
          return Text('Error: ${snapshotUser.error}');
        } else {
          final author = snapshotUser.data!;
          return FutureBuilder<Community>(
            future: communityFuture,
            builder: (context, snapshotCommunity) {
              if (snapshotCommunity.connectionState ==
                  ConnectionState.waiting) {
                return Container();
              } else if (snapshotCommunity.hasError) {
                return FutureBuilder<User>(
                  future: repostUserFuture,
                  builder: (context, snapshotRepostUser) {
                    final repostUser = snapshotRepostUser.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            postService.currentPostPage = 0;
                            postService.currentRepostPage = 0;
                            await userService
                                .findOtherUserById(widget.post.authorId);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  username: userService.searchedUser.username, fromPost: true, fromSearch: false,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  '${author.name} ${author.lastName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '@${author.username}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                'Not Found',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 5),
                            if (repostUser != null &&
                                repostUser.username != null &&
                                repostUser.username != '')
                              Row(
                                children: [
                                  Icon(
                                    size: 15,
                                    Icons.repeat,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '@${repostUser.username}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              } else {
                final community = snapshotCommunity.data!;
                return FutureBuilder<User>(
                  future: repostUserFuture,
                  builder: (context, snapshotRepostUser) {
                    final repostUser = snapshotRepostUser.data;
                    
// Condición para determinar si se debe usar GestureDetector
final bool useGestureDetector = widget.post.authorId != userService.user.id;

return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Envolver en GestureDetector si se cumple la condición
    if (useGestureDetector)
      GestureDetector(
        onTap: () async {
          postService.currentPostPage = 0;
          postService.currentRepostPage = 0;
          await userService.findOtherUserById(widget.post.authorId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                username: userService.searchedUser.username,
                fromPost: true, fromSearch: false,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              child: Text(
                '${author.name} ${author.lastName}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '@${author.username}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
    else
      // Usar solo el child si no se cumple la condición
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              '${author.name} ${author.lastName}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '@${author.username}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 150,
            child: Text(
              snapshotCommunity.hasData
                  ? 'For: ${community.name}'
                  : 'Not found',
              style: TextStyle(
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign
                  .right, // Justifica el texto a la derecha
            ),
          ),
          SizedBox(height: 5),
          if (repostUser != null &&
              repostUser.username != null &&
              repostUser.username != '')
            Row(
              children: [
                Icon(
                  size: 15,
                  Icons.repeat,
                  color: Colors.grey,
                ),
                Text(
                  '${repostUser.username}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  ],
);

                  },
                );
              }
            },
          );
        }
      },
    );
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

  Row _buildInteractions(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final postService = Provider.of<PostService>(context, listen: false);
    Color likeButtonColor = isLiked ? Colors.red : Colors.grey;
    Color repostButtonColor = isReposted ? Colors.blue : Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDateTime(widget.post.dateTime),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            _buildInteractionCount(
              Icons.comment,
              widget.post.postInteractions.commentsId.length,
              Colors.grey,
              false, // likedByCurrentUser: false
                 () async {
                    postService.currentCommentPage = 0;
                    postService.parentPost = widget.post;
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
              false, // likedByCurrentUser: false
              () async {
                if (isReposted) {
                  await postService.likeOrRepost(
                      "removeRepost", widget.post.id, userService.user.id);
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
                      likeButtonColor = isLiked ? Colors.red :Colors.grey;
                      // Remover el ID del usuario de la lista
                      widget.post.postInteractions.likeUsersId
                          .remove(userService.user.id);
                    });
                  } else {
                    await postService.likeOrRepost(
                        "addLike", widget.post.id, userService.user.id);
                    setState(() {
                      likeButtonColor = isLiked ? Colors.red :Colors.grey;
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
    );
  }

  Widget _buildContent() {
    String trimmedContent = widget.post.content!.trim();
    bool isLongContent = trimmedContent.length > 100;
    final int maxCharacters = 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: isLongContent
                  ? widget.isExtend
                      ? trimmedContent
                      : trimmedContent.substring(0, maxCharacters)
                  : trimmedContent,
              style: TextStyle(color: Colors.white),
              children: <TextSpan>[
                if (isLongContent && !widget.isExtend)
                  TextSpan(
                    text: ' Ver más',
                    style: TextStyle(color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    final bool hasText = widget.post.content.isEmpty;

    double mediaHeight = hasText
        ? 100
        : 50; // Determina la altura de los medios según si hay texto

    return SizedBox(
      height: mediaHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.post.photos.length + widget.post.videos.length,
        itemBuilder: (context, index) {
          if (index < widget.post.photos.length) {
            // Imágenes
            return GestureDetector(
              onTap: () {
                Utils.openImageInFullScreen(
                    context, widget.post.photos[index], widget.post);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image.network(
                  widget.post.photos[index],
                  width: mediaHeight,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            // Videos
            int videoIndex = index - widget.post.photos.length;
            String videoUrl = widget.post.videos[videoIndex];
            return FutureBuilder<Uint8List?>(
              future: _getVideoThumbnail(videoUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: mediaHeight,
                      color: Colors.grey, // Placeholder color
                      child: Center(
                        child:
                            CircularProgressIndicator(), // Placeholder while loading thumbnail
                      ),
                    ),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return GestureDetector(
                    onTap: () {
                      Utils.openVideoInFullScreen(
                          context, videoUrl, widget.post);
                    },
                    child: Container(
                      height: mediaHeight,
                      width: mediaHeight,
                      color: Colors.red,
                    ),
                  ); // Handle error or no thumbnail available
                } else {
                  return GestureDetector(
                    onTap: () {
                      Utils.openVideoInFullScreen(
                          context, videoUrl, widget.post);
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Image.memory(
                            snapshot.data!,
                            height: mediaHeight,
                            width: mediaHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              size: 20,
                              Icons.videocam,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: FutureBuilder<double?>(
                            future: Utils.getVideoDuration(videoUrl),
                            builder: (context, durationSnapshot) {
                              if (durationSnapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  durationSnapshot.hasError ||
                                  durationSnapshot.data == null) {
                                return Container();
                              } else {
                                return Text(
                                  Utils.formatDuration(durationSnapshot.data!),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<Uint8List?> _getVideoThumbnail(String videoPath) async {
    print("video Url: $videoPath");
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100,
      quality: 25,
    );
  }

  Widget _buildQuizz(BuildContext context, Post post) {
    final Size size = MediaQuery.of(context).size;
    String? firstPhoto = post.photos.isNotEmpty ? post.photos[0] : null;
    String quizDescription = '${post.quizz.description}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (firstPhoto != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              firstPhoto,
              width: size.width * 0.4,
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "assets/no-image.jpg",
              width: size.width * 0.4,
              height: size.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quizDescription,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(165, 91, 194, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuizScreen(quiz: post.quizz, post: post)));
                },
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 20),
                    Text(
                      'Play',
                      style: TextStyle(
                        fontFamily: "WorkSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Format the date and time in the specified format
    return '${_formatTime(dateTime)} · ${_formatDate(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    // Format the time
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String minute =
        dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    return '$hour:$minute$period';
  }

  String _formatDate(DateTime dateTime) {
    // Format the date
    return '${_getMonthName(dateTime.month)} ${dateTime.day} ${dateTime.year}';
  }

  String _getMonthName(int month) {
    // Get the month name
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
