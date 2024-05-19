import 'package:communiverse/utils.dart';
import 'package:communiverse/widgets/error_tokenExpired.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final bool fromPost;
  final bool fromSearch; // Nuevo parámetro username
  ProfileScreen(
      {required this.username,
      required this.fromPost,
      required this.fromSearch}); // Constructor

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
    final postService = Provider.of<PostService>(context, listen: false);
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    super.initState();
    if (widget.fromPost) {
      Future.wait([
        postService.findMyPostsPaged(userService.searchedUser.id),
        postService.findMyRePostsPaged(userService.searchedUser.id),
        communityService.getMyCommunities(userService.searchedUser.id),
      ]);
    }
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
        postService.findMyPostsPaged(userService.searchedUser.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      } else if (_currentIndex == 1) {
        postService.findMyRePostsPaged(userService.searchedUser.id).then((_) {
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  Map<String, dynamic> getEditedUserData() {
    final userService = Provider.of<UserService>(context, listen: false);

    final editedData = <String, dynamic>{
      'name': _firstNameController.text,
      'lastName': _lastNameController.text,
      'biography': _descriptionController.text,
      'username': _usernameController.text,
    };

    // Verificar si algún campo está vacío y si es así, actualizar el valor en editedData
    if (_firstNameController.text.length < 3) {
      editedData['name'] = userService.user.name;
    }
    if (_lastNameController.text.length < 3) {
      editedData['lastName'] = userService.user.lastName;
    }
    if (_usernameController.text.length < 3) {
      editedData['username'] = userService.user.username;
    }

    return editedData;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final postService = Provider.of<PostService>(context, listen: true);
    final userService = Provider.of<UserService>(context, listen: true);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  basicInfo(userService, userLoginRequestService, postService,
                      communityService, size),
                  SizedBox(height: size.height * 0.03),
                  _editingProfile
                      ? ProfileEditScreen(
                          user: userService.searchedUser,
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
                                  tabs: _tabs
                                      .map((tab) => Tab(text: tab))
                                      .toList(),
                                  onTap: (index) {
                                    setState(() async {
                                      if (index == 0) {
                                        postService.currentRepostPage = 0;
                                        await postService.findMyRePostsPaged(
                                            userService.searchedUser.id);
                                      } else if (index == 1) {
                                        postService.currentPostPage = 0;
                                        await postService.findMyPostsPaged(
                                            userService.searchedUser.id);
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
                                                scrollController:
                                                    _scrollController,
                                                buildProgressIndicator: () =>
                                                    _buildProgressIndicator(),
                                              ),
                                            ),

                                      // Contenido de la pestaña Reposts
                                      postService.myRePosts.isEmpty
                                          ? noPosts(size, "reposts")
                                          : Center(
                                              child: MyReposts(
                                                scrollController:
                                                    _scrollController,
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
        ),
      ],
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

  Column basicInfo(
      UserService userService,
      UserLoginRequestService userLoginRequestService,
      PostService postService,
      CommunityService communityService,
      Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            if (userService.searchedUser.id != userService.user.id ||
                widget.fromSearch)
              Positioned(
                top: 0,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    postService.currentPostPage = 0;
                    postService.currentRepostPage = 0;
                    await userService.searchOtherUsers(
                      userService.user.username,
                    );
                    postService.findMyPostsPaged(
                      userService.user.id,
                    );
                    postService.findMyRePostsPaged(
                      userService.user.id,
                    );
                    communityService.getMyCommunities(userService.user.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.4,
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_editingProfile) {
                            Utils().showImageOptions(
                              context,
                              userService,
                              userLoginRequestService,
                              () async {
                                String uniqueIdentifier = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                String updatedPhotoUrl =
                                    '${userService.searchedUser.photo}?$uniqueIdentifier';
                                setState(() {
                                  userService.searchedUser.photo =
                                      updatedPhotoUrl;
                                });
                              },
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 55,
                          // Usar la nueva URL con el identificador único para cargar la imagen
                          backgroundImage: userService.searchedUser.photo != ""
                              ? NetworkImage(userService.searchedUser.photo)
                              : AssetImage('assets/no-user.png')
                                  as ImageProvider<Object>?,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "@${userService.searchedUser.username}",
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            if (_editingProfile) {
                              // Lógica para guardar los cambios
                              Map<String, dynamic> editedData =
                                  getEditedUserData();
                              await userLoginRequestService.editUser(
                                UserLoginRequestService.userLoginRequest.id,
                                editedData,
                              );
                              await userService.findUserById(
                                UserLoginRequestService.userLoginRequest.id,
                              );
                              await userService.searchOtherUsers(
                                  UserLoginRequestService
                                      .userLoginRequest.username);
                              // Realizar alguna acción después de editar el usuario, si es necesario
                              setState(() {
                                _editingProfile =
                                    false; // Cambiar de nuevo al modo de visualización
                              });
                            } else if (userService.searchedUser.id ==
                                userService.user.id) {
                              setState(() {
                                _editingProfile =
                                    true; // Cambiar a modo de edición
                              });
                            } else {
                              // Lógica para seguir o dejar de seguir al usuario
                              if (userService.user.followedId
                                  .contains(userService.searchedUser.id)) {
                                // El usuario actual ya sigue al usuario buscado, dejar de seguir
                                await userService.follow(
                                  UserLoginRequestService.userLoginRequest.id,
                                  userService.searchedUser.id,
                                );
                              } else {
                                // El usuario actual aún no sigue al usuario buscado, seguir
                                await userService.follow(
                                  UserLoginRequestService.userLoginRequest.id,
                                  userService.searchedUser.id,
                                );
                              }
                            }
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Editing Error"),
                                  content: Text(error.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text("Accept"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                          backgroundColor:
                              Color.fromRGBO(222, 139, 255, 1), // Color de fondo
                        ),
                        child: Text(
                          _editingProfile
                              ? 'Save'
                              : userService.searchedUser.id == userService.user.id
                                  ? 'Edit'
                                  : userService.searchedUser.followersId
                                          .contains(userService.user.id)
                                      ? 'Followed'
                                      : 'Follow',
                        ),
                      )
                    ],
                  ),
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
                                '${userService.searchedUser.name} ${userService.searchedUser.lastName}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(222, 139, 255, 1)),
                              ),
                              _buildInfoLabel('Description'),
                              SizedBox(height: 2),
                              Text(
                                userService.searchedUser.biography,
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
                                '${userService.searchedUser.userStats.level}',
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
            if (userService.searchedUser.id == userService.user.id)
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
                        setState(() async {
                          await userService.findUserById(userService.searchedUser.id);
                          _editingProfile = !_editingProfile;
                        });
                      },
                    ),
                    if (_editingProfile)
                      IconButton(
                        icon: Icon(Icons.save, color: Colors.white),
                        onPressed: () async {
                          // Lógica para guardar los cambios
                          Map<String, dynamic> editedData = getEditedUserData();
                          try {
                            await userLoginRequestService.editUser(
                              UserLoginRequestService.userLoginRequest.id,
                              editedData,
                            );
                            await userService.findUserById(
                              UserLoginRequestService.userLoginRequest.id,
                            );
                            await userService.searchOtherUsers(
                                UserLoginRequestService
                                    .userLoginRequest.username);
                            // Realizar alguna acción después de editar el usuario, si es necesario
                            setState(() {
                              _editingProfile =
                                  false; // Cambiar de nuevo al modo de visualización
                            });
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Editing Error"),
                                  content: Text(error.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: Text("Accept"),
                                    ),
                                  ],
                                );
                              },
                            );
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
            _buildSection('Followers',
                userService.searchedUser.followersId.length.toString()),
            _buildSection('Followed',
                userService.searchedUser.followedId.length.toString()),
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
