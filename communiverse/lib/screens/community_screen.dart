import 'package:communiverse/models/models.dart';
import 'package:communiverse/utils.dart';
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _usernameController;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final userService = Provider.of<UserService>(context, listen: false);
    super.initState();
    _scrollController.addListener(_scrollListener);
    _firstNameController = TextEditingController(text: userService.user.name);
    _lastNameController =
        TextEditingController(text: userService.user.lastName);
    _descriptionController =
        TextEditingController(text: userService.user.biography);
    _usernameController =
        TextEditingController(text: userService.user.username);
  }

  @override
  void dispose() {
    print("dispose community screen");
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
        postService.getAllPostsFromCommunity(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 1) {
        postService.getAllQuizzFromCommunity(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  Map<String, dynamic> getEditedUserData() {
    return {
      'name': _firstNameController.text,
      'lastName': _lastNameController.text,
      'biography': _descriptionController.text,
      'username': _usernameController.text,
    };
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
              _buildCommunityInfo(size, userService),
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
                              postService.currentCommunityPostPage = 0;
                              await postService.getAllPostsFromCommunity(
                                  widget.community.id);
                            } else if (index == 1) {
                              postService.currentCommunityQuizzPage = 0;
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
                                ? noPosts(size, "posts")
                                : Center(
                                    child: CommunityPosts(
                                      scrollController: _scrollController,
                                      buildProgressIndicator: () =>
                                          _buildProgressIndicator(),
                                    ),
                                  ),

                            // Contenido de la pestaña Quizzes
                            postService.communityQuizzes.isEmpty
                                ? noPosts(size, "quizzes")
                                : Center(
                                    child: CommunityQuizzes(
                                      scrollController: _scrollController,
                                      buildProgressIndicator: () =>
                                          _buildProgressIndicator(),
                                    ),
                                  ),
                            // Contenido de la pestaña Communities
                            communityService.myCommunities.isEmpty
                                ? noPosts(size, "communities")
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

  Widget _buildCommunityInfo(Size size, UserService userService) {
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
                  onPressed: () {
                    // Implementa la lógica para unirse o dejar la comunidad
                  },
                  child: Text('Leave'),
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

  Padding noPosts(Size size, String content) {
    return Padding(
      padding: EdgeInsets.only(
          top: size.height *
              0.15), // Ajusta el espacio superior según sea necesario
      child: Text(
        'There are no $content at the moment',
        textAlign: TextAlign.center, // Alinea el texto al centro
      ),
    );
  }

  Widget _buildSection(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 0.5)),
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
