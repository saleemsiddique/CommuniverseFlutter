import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
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
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
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
                            postService.myPosts.isEmpty
                                ? noPosts(size)
                                : Center(
                              child: MyPosts(scrollController: _scrollController, buildProgressIndicator: () => _buildProgressIndicator(),),
                            ),

                            // Contenido de la pestaña Reposts
                            postService.myRePosts.isEmpty
                                ? noPosts(size)
                                : Center(
                              child: MyReposts(scrollController: _scrollController, buildProgressIndicator: () => _buildProgressIndicator(),),
                            ),
                            // Contenido de la pestaña Communities
                            postService.myRePosts.isEmpty
                                ? noPosts(size)
                                : Center(
                              child: MyCommunitiesWidget(),
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

  Padding noPosts(Size size) {
    return Padding(
      padding: EdgeInsets.only(
          top: size.height *
              0.15), // Ajusta el espacio superior según sea necesario
      child: Text(
        'There are no posts at the moment',
        textAlign: TextAlign.center, // Alinea el texto al centro
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
