import 'package:communiverse/models/models.dart';
import 'package:communiverse/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  final Community community;

  CommunityScreen({required this.community});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _currentIndex = 0;
  final List<String> _tabs = ['Popular Posts', 'Pupular Quizzes', 'My Space'];
  bool _loading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    communityService.chosenCommunity = widget.community;
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    print("dispose community screen");
    _scrollController.dispose();
    final postService = Provider.of<PostService>(context, listen: false);
    postService.communityPosts = [];
    postService.communityQuizzes = [];
    postService.communitymySpacePosts = [];
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
        postService.getAllPostsFromCommunity(widget.community.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 1) {
        postService.getAllQuizzFromCommunity(widget.community.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 2) {
        postService
            .getMySpaceFromCommunity(
                widget.community.id, userService.user.followedId)
            .then((_) {
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
    final communityService = Provider.of<CommunityService>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04),
                  _buildCommunityInfo(size, userService, communityService),
                  SizedBox(height: size.height * 0.03),
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
                              setState(() async {
                                if (index == 0) {
                                  postService.currentMySpacePage = 0;
                                  postService.currentCommunityQuizzPage = 0;
                                  await postService.getMySpaceFromCommunity(
                                      widget.community.id,
                                      userService.user.followedId);
                                  await postService.getAllQuizzFromCommunity(
                                      widget.community.id);
                                } else if (index == 1) {
                                  postService.currentMySpacePage = 0;
                                  postService.currentCommunityPostPage = 0;
                                  await postService.getMySpaceFromCommunity(
                                      widget.community.id,
                                      userService.user.followedId);
                                  await postService.getAllPostsFromCommunity(
                                      widget.community.id);
                                } else if (index == 2) {
                                  postService.currentCommunityQuizzPage = 0;
                                  postService.currentCommunityPostPage = 0;
                                  await postService.getAllPostsFromCommunity(
                                      widget.community.id);
                                  await postService.getAllQuizzFromCommunity(
                                      widget.community.id);
                                }
                                _currentIndex = index;
                              });
                            },
                            indicatorColor: Colors.white,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Contenido de la pestaña Posts
                                postService.communityPosts.isEmpty
                                    ? _noPosts(size, "posts")
                                    : Center(
                                        child: CommunityPosts(
                                          scrollController: _scrollController,
                                          buildProgressIndicator: () =>
                                              _buildProgressIndicator(),
                                        ),
                                      ),

                                // Contenido de la pestaña Quizzes
                                postService.communityQuizzes.isEmpty
                                    ? _noPosts(size, "quizzes")
                                    : Center(
                                        child: CommunityQuizzes(
                                          scrollController: _scrollController,
                                          buildProgressIndicator: () =>
                                              _buildProgressIndicator(),
                                        ),
                                      ),
                                // Contenido de la pestaña Communities
                                postService.communitymySpacePosts.isEmpty
                                    ? _noPosts(size, "posts")
                                    : Center(
                                        child: CommunityMySpace(
                                          scrollController: _scrollController,
                                          buildProgressIndicator: () =>
                                              _buildProgressIndicator(),
                                        ),
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
          Positioned(
            top: 20,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: (userService.user.createdCommunities
                        .contains(widget.community.id) ||
                    userService.user.moderatedCommunities
                        .contains(widget.community.id) ||
                    userService.user.memberCommunities
                        .contains(widget.community.id))
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(
                              user: userService.user,
                              community: widget.community),
                        ),
                      );
                    },
                    backgroundColor: Color.fromRGBO(165, 91, 194, 1),
                    child: Icon(Icons.add),
                  )
                : SizedBox
                    .shrink(), // Si el usuario no está en ninguna de las listas, oculta el botón
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityInfo(Size size, UserService userService, CommunityService communityService) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de la comunidad
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.community.photo),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Alinea los elementos en el espacio vertical disponible
              children: [
                // Nombre de la comunidad
                Text(
                  widget.community.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        10), // Agrega espacio entre el nombre y el siguiente elemento
                // Número de miembros
                Text(
                  '${widget.community.followers} Members',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                    height:
                        10), // Agrega más espacio entre el número de miembros y el botón
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 40)), // Set button size
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(
                          165, 91, 194, 1), // Set button background color
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Set border radius
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (userService.user.memberCommunities
                        .contains(widget.community.id)) {
                      // Si el usuario ya es miembro de la comunidad, debe dejarla
                      userService.joinCommunity(
                          widget.community.id, userService.user.id);
                    } else if (userService.user.moderatedCommunities
                            .contains(widget.community.id) ||
                        userService.user.createdCommunities
                            .contains(widget.community.id)) {
                      // Si el usuario es moderador o creador de la comunidad, dirigirlo a la página de administración
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityManageScreen(
                            community: widget.community,
                          ),
                        ),
                      );
                    } else {
                      try {
                        // Si el usuario no es miembro de la comunidad, debe unirse
                        await userService.joinCommunity(
                            widget.community.id, userService.user.id);
                        await communityService.getMyCommunities(userService.user.id);
                      } catch (e) {
                        // Captura cualquier excepción general
                        print("Excepción atrapada: $e");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text(
                                  "No puedes unirte a esta comunidad porque has sido baneado."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    userService.user.memberCommunities
                            .contains(widget.community.id)
                        ? 'Leave'
                        : (userService.user.moderatedCommunities
                                    .contains(widget.community.id) ||
                                userService.user.createdCommunities
                                    .contains(widget.community.id))
                            ? 'Manage'
                            : 'Join',
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _noPosts(Size size, String content) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.15),
      child: Text(
        'There are no $content at the moment',
        textAlign: TextAlign.center,
      ),
    );
  }
}
