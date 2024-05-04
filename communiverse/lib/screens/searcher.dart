import 'package:flutter/material.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/screens/user_screen.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchProfilesPage extends StatefulWidget {
  @override
  _SearchProfilesPageState createState() => _SearchProfilesPageState();
}

class _SearchProfilesPageState extends State<SearchProfilesPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    final userService = Provider.of<UserService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 40), // Ajuste de la posición horizontal del TextField
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.length >= 3) {
                        userService.searchUsersList(value);
                        communityService.searchCommunityList(value);
                      }
                      if (value.length < 3) {
                        setState(() {
                          userService.searchedUsersList.clear();
                          communityService.searchedCommunityList.clear();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            userService.searchedUsersList.clear();
                          });
                        },
                        color: Color.fromRGBO(222, 139, 255, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'Users'),
                            Tab(text: 'Communities'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                itemCount:
                                    userService.searchedUsersList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      postService.currentPostPage = 0;
                                      postService.currentRepostPage = 0;
                                      await userService.searchOtherUsers(
                                        userService.searchedUsersList[index]
                                            .username,
                                      );
                                      await Future.wait([
                                        postService.findMyPostsPaged(
                                          userService.searchedUsersList[index]
                                              .id,
                                        ),
                                        postService.findMyRePostsPaged(
                                          userService.searchedUsersList[index]
                                              .id,
                                        ),
                                        communityService.getMyCommunities(
                                          userService.searchedUsersList[index]
                                              .id,
                                        ),
                                      ]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                            username: userService
                                                .searchedUsersList[index]
                                                .username,
                                          ),
                                        ),
                                      );
                                    },
                                    child: UserProfileItem(
                                      username: userService
                                          .searchedUsersList[index].username,
                                      fullname:
                                          "${userService.searchedUsersList[index].name} ${userService.searchedUsersList[index].lastName}",
                                      profilePic: userService
                                          .searchedUsersList[index].photo,
                                    ),
                                  );
                                },
                              ),
                              ListView.builder(
                                itemCount: communityService
                                    .searchedCommunityList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      postService.currentCommunityPostPage =
                                          0;
                                      postService.currentCommunityQuizzPage =
                                          0;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommunityScreen(
                                            community: communityService
                                                .searchedCommunityList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CommunityItem(
                                      name: communityService
                                          .searchedCommunityList[index].name,
                                      photo: communityService
                                          .searchedCommunityList[index].photo,
                                      followers: communityService
                                          .searchedCommunityList[index]
                                          .followers,
                                    ),
                                  );
                                },
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
          Positioned(
            top: 45,
            left: 3,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
