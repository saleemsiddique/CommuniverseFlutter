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
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            if (post.content != null) _buildContent(),
            if (post.photos != null) _buildPhotos(),
            if (post.videos != null) _buildVideos(),
            if (post.postInteractions != null) _buildInteractions(),
            if (post.repostUserId != null) _buildRepostUser(),
            if (post.quizz != null) _buildQuizz(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<User>(
      future: Provider.of<PostService>(context, listen: false)
          .findPostAuthor(post.authorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera el resultado del Future
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final author = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${author.name} ${author.lastName}',style: TextStyle(color: Colors.black),),
              Text('${author.username}'),
            ],
          );
        }
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(post.content!),
    );
  }

  Widget _buildPhotos() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.photos!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Image.network(
              post.photos![index],
              width: 150,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideos() {
    return Container(
      height: 200,
      color: Colors.grey, // Placeholder color
      child: Center(
        child: Icon(
          Icons.play_circle_fill,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInteractions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.favorite_border),
        Icon(Icons.comment),
        Icon(Icons.share),
      ],
    );
  }

  Widget _buildRepostUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Repost by: ${post.repostUserId}',
        style: TextStyle(fontWeight: FontWeight.bold),
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
      ],
    );
  }
}
