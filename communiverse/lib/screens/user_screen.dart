import 'package:communiverse/utils.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;
  final List<String> _tabs = ['Posts', 'Reposts', 'Communities'];
  bool _loading = false;
  bool _editingProfile = false;
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
        postService.findMyPostsPaged(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 1) {
        postService.findMyRePostsPaged(userService.user.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  Map<String, dynamic> getEditedUserData() {
    return {
      'firstName': _firstNameController.text,
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
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              basicInfo(userService, userLoginRequestService, size),
              SizedBox(height: size.height * 0.03),
              _editingProfile
                  ? ProfileEditScreen(
                      user: userService.user,
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      descriptionController: _descriptionController,
                      usernameController: _usernameController,
                      getEditedUserData: () => getEditedUserData(),
                    )
                  : DefaultTabController(
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
                                    postService.currentRepostPage = 0;
                                    await postService.findMyRePostsPaged(
                                        UserLoginRequestService
                                            .userLoginRequest.id);
                                  } else if (index == 1) {
                                    postService.currentPostPage = 0;
                                    await postService.findMyPostsPaged(
                                        UserLoginRequestService
                                            .userLoginRequest.id);
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
                                  postService.myPosts.isEmpty
                                      ? noPosts(size, "posts")
                                      : Center(
                                          child: MyPosts(
                                            scrollController: _scrollController,
                                            buildProgressIndicator: () =>
                                                _buildProgressIndicator(),
                                          ),
                                        ),

                                  // Contenido de la pestaña Reposts
                                  postService.myRePosts.isEmpty
                                      ? noPosts(size, "reposts")
                                      : Center(
                                          child: MyReposts(
                                            scrollController: _scrollController,
                                            buildProgressIndicator: () =>
                                                _buildProgressIndicator(),
                                          ),
                                        ),
                                  // Contenido de la pestaña Communities
                                  postService.myRePosts.isEmpty
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

  Column basicInfo(UserService userService,
      UserLoginRequestService userLoginRequestService, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_editingProfile) {
                          Utils().showImageOptions(
                              context, userService, userLoginRequestService);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 55,
                        backgroundImage: userService.user.photo != ""
                            ? NetworkImage(
                                "${userService.user.photo}?${DateTime.now().millisecondsSinceEpoch}")
                            : AssetImage('assets/no-user.png')
                                as ImageProvider<Object>?,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      userService.user.username,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(width: size.width * 0.05),
                _editingProfile
                    ? Container()
                    : Container(
                        width: size.width * 0.44,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
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
                                maxLines: 6,
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
                      ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: _editingProfile
                        ? Icon(Icons.close, color: Colors.white)
                        : Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _editingProfile = !_editingProfile;
                      });
                    },
                  ),
                  if (_editingProfile)
                    IconButton(
                      icon: Icon(Icons.save,
                          color: Colors.white), // Botón para guardar cambios
                      onPressed: () async {
                        // Obtener los datos editados del ProfileEditScreen
                        print(
                            "Esta es la data para editar: ${getEditedUserData()}");
                        Map<String, dynamic> editedData = getEditedUserData();

                        try {
                          // Llamar a la función editUser de UserLoginRequestService con los datos editados
                          await userLoginRequestService.editUser(
                            userService.user.id,
                            editedData,
                          );
                          await userService.findUserById(
                              UserLoginRequestService.userLoginRequest.id);
                          // Realizar alguna acción después de editar el usuario, si es necesario
                          setState(() {
                            _editingProfile = !_editingProfile;
                          });
                        } catch (error) {
                          // Manejar el error si falla la edición del usuario
                        }
                      },
                    ),
                  if (!_editingProfile)
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, 'settings');
                      },
                    ),
                ],
              ),
            ),
          ],
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
