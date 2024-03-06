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
  bool _loading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    final postService = Provider.of<PostService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    if (!_loading &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _loading = true;
      });
      if (_currentIndex == 0) {
        postService.currentRepostPage = 0;
        postService.findMyPostsPaged(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 1) {
        postService.currentPostPage = 0;
        postService.findMyRePostsPaged(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

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
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: postService.myPosts.length +
                                          1, // +1 para el indicador de progreso
                                      itemBuilder: (context, index) {
                                        if (index <
                                            postService.myPosts.length) {
                                          final post =
                                              postService.myPosts[index];
                                          return PostWidget(post: post);
                                        } else {
                                          return _buildProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Contenido de la pestaña Reposts
                            Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: postService.myRePosts.length +
                                          1, // +1 para el indicador de progreso
                                      itemBuilder: (context, index) {
                                        if (index <
                                            postService.myRePosts.length) {
                                          final post =
                                              postService.myRePosts[index];
                                          return PostWidget(post: post);
                                        } else {
                                          return _buildProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildProgressIndicator() {
    return _loading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : Container();
  }
  /*
Center(
  child: NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification scrollInfo) {
      if (!postService.isLoading &&
          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
        // Reached the end of the list, load more data if there is more to load
        if (!postService.allDataLoaded) {
          postService.findMyRePosts(userService.user.id);
        }
      }
      return true;
    },
    child: ListView.builder(
      itemCount: postService.myRePosts.posts.length + (postService.allDataLoaded ? 0 : 1), // +1 for loading indicator if more data can be loaded
      itemBuilder: (context, index) {
        if (index < postService.myRePosts.posts.length) {
          final post = postService.myRePosts.posts[index];
          return PostWidget(post: post);
        } else if (postService.isLoading) {
          // Show a loading indicator while more content is being loaded
          return CircularProgressIndicator();
        } else {
          // If isLoading is false and all data is loaded, show an empty container
          return Container();
        }
      },
    ),
  ),
),
  */

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
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(222, 139, 255, 1)),
                      ),
                      _buildInfoLabel('Description'),
                      SizedBox(height: 2),
                      Text(
                        userService.user.biography,
                        overflow: TextOverflow.clip,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(222, 139, 255, 1),
                        ),
                      ),
                      _buildInfoLabel('Level'),
                      SizedBox(height: 2),
                      Text(
                        '${userService.user.userStats.level}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(222, 139, 255, 1)),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(222, 139, 255, 1)),
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
