import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class CommunityManageScreen extends StatefulWidget {
  final Community community;

  const CommunityManageScreen({Key? key, required this.community})
      : super(key: key);

  @override
  _CommunityManageScreenState createState() => _CommunityManageScreenState();
}

class _CommunityManageScreenState extends State<CommunityManageScreen> {
  bool viewMembersTapped = false;
  bool viewBannedTapped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Scaffold");
    final userService = Provider.of<UserService>(context, listen: true);
    print("Created ${userService.user.createdCommunities}");
    print("Moderated ${userService.user.moderatedCommunities}");
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Manage Community'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (viewMembersTapped) {
              setState(() {
                viewMembersTapped = false;
              });
            } else if (viewBannedTapped) {
              setState(() {
                viewBannedTapped = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: viewMembersTapped
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Divider(color: Colors.white),
                  if (userService.searchedCommunityUsersList.isNotEmpty)
                    ...userService.searchedCommunityUsersList
                        .map(
                          (user) => CommunityUserProfileItem(
                              user: user, community: widget.community),
                        )
                        .toList(),
                ],
              ),
            )
          : viewBannedTapped
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      Divider(color: Colors.white),
                      if (communityService.bannedUsers.isNotEmpty)
                        ...communityService.bannedUsers
                            .map(
                              (user) => CommunityBannedProfileItem(
                                  user: user, community: widget.community),
                            )
                            .toList(),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      Divider(color: Colors.white),
                      if (userService.user.moderatedCommunities
                          .contains(widget.community.id)) ...[
                        ListTile(
                          title: Text('View Members',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            await userService
                                .searchCommunityUsersList(widget.community.id);
                            setState(() {
                              viewMembersTapped = true;
                            });
                          },
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          title: Text('Banned Users',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            await communityService
                                .searchCommunityBannedUsersList(
                                    widget.community.id);
                            setState(() {
                              viewBannedTapped = true;
                            });
                          },
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          title: Text('Leave Community',
                              style: TextStyle(color: Colors.red)),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmation"),
                                  content: Text(
                                      "Are you sure you want to leave this community?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        userService.joinCommunity(
                                            widget.community.id,
                                            userService.user.id);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommunityScreen(
                                                        community:
                                                            widget.community)));
                                      },
                                      child: Text("Confirm"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ] else if (userService.user.createdCommunities
                          .contains(widget.community.id)) ...[
                        ListTile(
                          title: Text('View Members',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            await userService
                                .searchCommunityUsersList(widget.community.id);
                            setState(() {
                              viewMembersTapped = true;
                            });
                          },
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          title: Text('Banned Users',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            await communityService
                                .searchCommunityBannedUsersList(
                                    widget.community.id);
                            setState(() {
                              viewBannedTapped = true;
                            });
                          },
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          title: Text('Change Community Info',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCommunityScreen(
                                  user: userService.user,
                                  communityToEdit:
                                      communityService.chosenCommunity,
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          title: Text('Eliminate Community',
                              style: TextStyle(color: Colors.red)),
                          onTap: () {
                            if (widget.community.followers == 0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController confirmController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text("Confirmación"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                            "Para confirmar, por favor escriba 'CONFIRMAR' en mayúsculas:"),
                                        TextField(
                                          controller: confirmController,
                                          autofocus: true,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "CONFIRMAR",
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (confirmController.text ==
                                              'CONFIRMAR') {
                                            await userService.deleteCommunity(
                                                widget.community.id);
                                            await communityService
                                                .getMyCommunities(
                                                    userService.user.id);
                                            await userService.findUserById(
                                                userService.user.id);
                                            Navigator.pushReplacementNamed(
                                                context, 'home');
                                          } else {
                                            // Mostrar un mensaje de error
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Por favor, escriba "CONFIRMAR" en mayúsculas para confirmar.'),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text("Confirmar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Unable to delete"),
                                    content: Text(
                                        "You can't delete this community. Please make another user the admin/creator first."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
