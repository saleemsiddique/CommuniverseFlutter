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

class PostWidget extends StatelessWidget {
  final Post post;
  final bool isExtend;
  const PostWidget({Key? key, required this.post, required this.isExtend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    final Size size = MediaQuery.of(context).size;

    // Verificar si el post tiene media
    final bool hasMedia = post.photos.isNotEmpty || post.videos.isNotEmpty;
    
    // Definir la altura del Card
    double cardHeight = hasMedia ? size.height * 0.32 : size.height * 0.25;

    return GestureDetector(
      onTap: () async {
        postService.currentCommentPage = 0;
        await postService.findMyCommentsPaged(post.id);
        // Navegar a la pantalla de comentarios cuando se toque el post
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsScreen(post: post, postService: postService),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(7),
        child: SizedBox(
          height: cardHeight,
          child: Card(
            color: Color.fromRGBO(46, 30, 47, 1),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (post.quizz == Quizz.empty()) ...[
                          _buildHeader(context),
                          if (post.content != '') _buildContent(),
                          SizedBox(height: 10),
                          if (hasMedia) _buildMedia(),
                        ] else ...[
                          _buildHeader(context),
                          SizedBox(height: 15),
                          _buildQuizz(context, post),
                          SizedBox(height: 1.4),
                        ]
                      ],
                    ),
                  ),
                  _buildInteractions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: false);

    // Almacenar los datos recuperados en variables locales
    final authorFuture = postService.findPostAuthor(post.authorId);
    final communityFuture = postService.findPostCommunity(post.communityId);
    final repostUserId = post.repostUserId;

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
                return Text('Error: ${snapshotCommunity.error}');
              } else {
                final community = snapshotCommunity.data!;
                return FutureBuilder<User>(
                  future: repostUserFuture,
                  builder: (context, snapshotRepostUser) {
                    final repostUser = snapshotRepostUser.data;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${author.name} ${author.lastName}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${author.username}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'For: ${community.name}',
                              style: TextStyle(
                                color: Colors.grey,
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
                                  SizedBox(width: 3),
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

  Row _buildInteractions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDateTime(post.dateTime),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            _buildInteractionCount(
              Icons.comment,
              post.postInteractions.commentsId.length,
            ),
            SizedBox(width: 10),
            _buildInteractionCount(
              Icons.repeat,
              post.postInteractions.reposts,
            ),
            SizedBox(width: 10),
            _buildInteractionCount(
              Icons.favorite_border,
              post.postInteractions.likes,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
  String trimmedContent = post.content!.trim();
  bool isLongContent = trimmedContent.length > 200;
  final int maxCharacters = 150;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: isLongContent
                ? isExtend ? trimmedContent : trimmedContent.substring(0, maxCharacters)
                : trimmedContent,
            style: TextStyle(color: Colors.white),
            children: <TextSpan>[
              if (isLongContent && !isExtend)
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
  int videoIndex = 0;

  return SizedBox(
    height: 50,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: post.photos.length + post.videos.length,
      itemBuilder: (context, index) {
        if (index < post.photos.length) {
          // Imágenes
          return GestureDetector(
            onTap: () {
              Utils.openImageInFullScreen(context, post.photos[index], post);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Image.network(
                post.photos[index],
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          // Videos
          return FutureBuilder<Uint8List?>(
            future: _getVideoThumbnail(post.videos[index - post.photos.length]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 50,
                    color: Colors.grey, // Placeholder color
                    child: Center(
                      child: CircularProgressIndicator(), // Placeholder while loading thumbnail
                    ),
                  ),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return Container(height: 20, width: 20, color: Colors.red,); // Handle error or no thumbnail available
              } else {
                return GestureDetector(
                  onTap: () {
                    Utils.openVideoInFullScreen(
                        context, post.videos[index - post.photos.length], post);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Image.memory(
                      snapshot.data!,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
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

Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {
  print("video Url: $videoUrl");
  // Obtener miniatura del video usando el paquete video_thumbnail
  final thumbnail = await VideoThumbnail.thumbnailData(
    video: videoUrl,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 100, // Ancho máximo de la miniatura
    quality: 25, // Calidad de la miniatura (0 - 100)
  );
  return thumbnail;
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
              SizedBox(height: size.height * 0.1),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(165, 91, 194, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // Action to play the quiz
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

  Widget _buildInteractionCount(IconData icon, int count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        SizedBox(width: 3),
        Text(
          '$count',
          style: TextStyle(
            color: Colors.grey,
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
