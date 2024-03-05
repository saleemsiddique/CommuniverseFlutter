import 'package:communiverse/services/post_service.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;
  final List<String> _tabs = ['Posts', 'Reposts', 'Communities'];

  @override
  Widget build(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  final postService = Provider.of<PostService>(context, listen: true);
  final userService = Provider.of<UserService>(context, listen: true);
  return Scaffold(
    body: Padding(
      padding: EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            basicInfo(userService, size),
            SizedBox(height: size.height * 0.05),
            DefaultTabController(
              length: _tabs.length,
              child: Container(
                height: size.height * 0.9,
                color: Color.fromRGBO(165, 91, 194, 0.2),
                child: Column(
                  children: [
                    TabBar(
                      tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      indicatorColor: Colors.white,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Contenido de la pestaña Posts
                          Center(
                            child: ListView.builder(
                              itemCount: postService.myPosts.length,
                              itemBuilder: (context, index) {
                                final post = postService.myPosts[index];
                                return PostWidget(post: post);
                              },
                            ),
                          ),
                          // Contenido de la pestaña Reposts
                          Center(
                            child: Text('Contenido de Reposts'),
                          ),
                          // Contenido de la pestaña Communities
                          Center(
                            child: Text('Contenido de Communities'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Column basicInfo(UserService userService, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 55,
                    backgroundImage: userService.user.photo != ''
                        ? NetworkImage(userService.user.photo)
                        : AssetImage('assets/no-user.png')
                            as ImageProvider<Object>?,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userService.user.username,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(width: size.width * 0.05),
              Container(
                width: size.width * 0.44, // Set your desired width here
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoLabel('Name'),
                      SizedBox(height: 2),
                      Text(
                        '${userService.user.name} ${userService.user.lastName}',
                        style:
                            TextStyle(fontSize: 15,color: Color.fromRGBO(222, 139, 255, 1)),
                      ),
                      _buildInfoLabel('Description'),
                      SizedBox(height: 2),
                      Text(
                        userService.user.biography,
                        overflow: TextOverflow.clip,
                        maxLines: 5,
                        style: TextStyle(fontSize: 15,
                          color: Color.fromRGBO(222, 139, 255, 1),
                        ),
                      ),
                      _buildInfoLabel('Level'),
                      SizedBox(height: 2),
                      Text(
                        '${userService.user.userStats.level}',
                        style:
                            TextStyle(fontSize: 15,color: Color.fromRGBO(222, 139, 255, 1)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSection(
                'Followers', userService.user.followersId.length.toString()),
            _buildSection(
                'Followed', userService.user.followedId.length.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(222, 139, 255, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLabel(String label) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
