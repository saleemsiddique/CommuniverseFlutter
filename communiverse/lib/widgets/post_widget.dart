import 'package:communiverse/services/post_service.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(7),
    child:Card(
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
                  _buildHeader(context),
                  if (post.content != '') _buildContent(),
                  if (post.photos != [] || post.videos != []) _buildMedia(),
                  if (post.quizz != Quizz.empty()) _buildQuizz(),
                ],
              ),
            ),
            _buildInteractions(),
          ],
        ),
      ),
    ));
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
                    post.postInteractions.comments.length,
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

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<User>(
      future: Provider.of<PostService>(context, listen: false)
          .findPostAuthor(post.authorId),
      builder: (context, snapshotUser) {
        if (snapshotUser.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshotUser.hasError) {
          return Text('Error: ${snapshotUser.error}');
        } else {
          final author = snapshotUser.data!;
          return FutureBuilder<Community>(
            future: Provider.of<PostService>(context, listen: false)
                .findPostCommunity(post.communityId),
            builder: (context, snapshotCommunity) {
              if (snapshotCommunity.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshotCommunity.hasError) {
                return Text('Error: ${snapshotCommunity.error}');
              } else {
                final community = snapshotCommunity.data!;
                return FutureBuilder<User>(
                  future: post.repostUserId != ''
                      ? Provider.of<PostService>(context, listen: false)
                          .findPostAuthor(post.repostUserId!)
                      : Future.value(User.empty()),
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
                            if (repostUser?.username != null &&
                                repostUser?.username != '')
                              Row(
                                children: [
                                  Icon(
                                    size: 15,
                                    Icons.repeat,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '${repostUser?.username}',
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

Widget _buildContent() {
  String trimmedContent = post.content!.trim();
  bool isLongContent = trimmedContent.length > 20;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLongContent ? trimmedContent.substring(0, 20) + "..." : trimmedContent,
          style: TextStyle(color: Colors.white),
        ),
        if (isLongContent)
          TextButton(
            onPressed: () {
              // Acción para expandir o mostrar más contenido
            },
            child: Text(
              "Ver más",
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    ),
  );
}


  Widget _buildMedia() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.photos.length + (post.videos.length),
        itemBuilder: (context, index) {
          if (index < post.photos.length) {
            return Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Image.network(
                post.photos[index],
                width: 50,
                fit: BoxFit.cover,
              ),
            );
          } else {
            // Video
            return Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Container(
                color: Colors.grey, // Placeholder color
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuizz() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 8),
        Text(
          'Question 1',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Option A'),
        Text('Option B'),
        Text('Option C'),
        SizedBox(height: 16),
        Text(
          'Question 2',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Option X'),
        Text('Option Y'),
        Text('Option Z'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Action to play the quiz
          },
          child: Row(
            children: [
              Icon(Icons.play_arrow),
              SizedBox(width: 8),
              Text('Jugar'),
            ],
          ),
        ),
      ],
    );
  }
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