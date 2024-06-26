import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityCard extends StatelessWidget {
  final Community community;

  const CommunityCard({Key? key, required this.community}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final postService = Provider.of<PostService>(context, listen: false);
        final userService = Provider.of<UserService>(context, listen: false);
        postService.currentCommunityPostPage = 0;
        postService.currentCommunityQuizzPage = 0;
        postService.currentMySpacePage = 0;
        await Future.wait([
          postService.getAllPostsFromCommunity(community.id),
          postService.getAllQuizzFromCommunity(community.id),
          postService.getMySpaceFromCommunity(
              community.id, userService.user.followedId),
        ]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityScreen(
              community: community,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8, // Aumentar el valor de elevación para un borde más grueso
        shadowColor: Color.fromRGBO(126, 75, 138, 1),
        color: Color.fromRGBO(84, 50, 92, 1),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Ajustar el radio del borde
          side: BorderSide(
            color: Color.fromRGBO(126, 75, 138, 1), // Color del borde
            width: 1.0, // Grosor del borde
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(3.0),
          height: 160.0,
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 115.0,
                width: 115.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: community.photo != ""
                          ? NetworkImage(community.photo)
                          : Image.asset('assets/no-image.jpg').image,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Text(
                        community.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      community.followers.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
