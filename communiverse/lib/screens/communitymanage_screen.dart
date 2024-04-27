import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class CommunityUserProfileItem extends StatefulWidget {
  final User user;
  final Community community;

  CommunityUserProfileItem({required this.user, required this.community});

  @override
  State<CommunityUserProfileItem> createState() =>
      _CommunityUserProfileItemState();
}

class _CommunityUserProfileItemState extends State<CommunityUserProfileItem> {
  bool isPromote = false;
  bool isDemote = false;
  bool isKick = false;

  @override
  Widget build(BuildContext context) {
    print("La otra");
    final userService = Provider.of<UserService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);

    bool isCreator =
        widget.user.createdCommunities.contains(widget.community.id);
    bool isModerator =
        widget.user.moderatedCommunities.contains(widget.community.id);
    bool isMember = widget.user.memberCommunities.contains(widget.community.id);

    bool imHim = userService.user.id == widget.user.id;

    bool iAmCreator =
        userService.user.createdCommunities.contains(widget.community.id);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            widget.user.photo), // Asigna la imagen del perfil como avatar
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.username,
            style:
                TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
          ),
          Text(
            '${widget.user.name} ${widget.user.lastName}',
            style:
                TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
          ),
          if (isCreator) _buildRoleButton(context, 'Creator'),
          if (isModerator) _buildRoleButton(context, 'Moderator'),
          if (isMember) _buildRoleButton(context, 'Member'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_upward,
                color: isMember || isModerator && iAmCreator && !imHim
                    ? Colors.green
                    : Colors.grey),
            onPressed: isMember || isModerator && iAmCreator && !imHim
                ? () async {
                    bool? promote = await showPromoteConfirmationDialog(
                        context,
                        widget.user,
                        widget.community.id,
                        userService,
                        communityService);
                    if (promote != null && promote) {
                      await userService.promoteInCommunity(widget.community.id,
                          widget.user.id, userService.user.id);
                      setState(() {
                        isPromote = false;
                      });
                    }
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.arrow_downward,
                color: isModerator && iAmCreator && !imHim
                    ? Colors.orange
                    : Colors.grey),
            onPressed: isModerator && !imHim
                ? () async {
                    bool? demote = await _showDemoteConfirmationDialog(
                        context, widget.user, widget.community.id, userService);
                    if (demote != null && demote) {
                      await userService.demoteInCommunity(
                          widget.community.id, widget.user.id);
                      setState(() {
                        isDemote = false;
                      });
                    }
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.cancel,
                color: !imHim && !isCreator && isModerator
                    ? Colors.red
                    : Colors.grey),
            onPressed: () async {
              bool? kick = await _showKickConfirmationDialog(
                  context, widget.user, widget.community.id, userService);
              if (kick != null && kick) {
                await userService.kickFromCommunity(
                    widget.community.id, widget.user.id);
                setState(() {
                  isKick = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role) {
    Color buttonColor = Colors.grey;
    Color textColor = Colors.white;
    double fontSize = 14.0;

    if (role == 'Creator') {
      buttonColor = Colors.blueGrey;
    } else if (role == 'Moderator') {
      buttonColor = Colors.indigo;
    }

    return Container(
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Text(
          role,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Future<bool?> showPromoteConfirmationDialog(
      BuildContext context,
      User user,
      String communityId,
      UserService userService,
      CommunityService communityService) async {
    bool isModerator = user.moderatedCommunities.contains(communityId);
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Promote User"),
          content: isModerator
              ? Text("Are you sure you want to promote this user to Creator?")
              : Text(
                  "Are you sure you want to promote this user to Moderator?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            isModerator
                ? TextButton(
                    child: Text("PROMOTE"),
                    onPressed: () async {
                      TextEditingController confirmController =
                          TextEditingController();
                      await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "To confirm, please enter 'CONFIRM' in uppercase:",
                                ),
                                TextField(
                                  controller: confirmController,
                                  autofocus: true,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "CONFIRM",
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (confirmController.text == 'CONFIRM') {
                                    await userService.promoteInCommunity(
                                        communityId,
                                        user.id,
                                        userService.user.id);
                                    await communityService
                                        .getMyCommunities(userService.user.id);
                                    await userService
                                        .findUserById(userService.user.id);
                                    Navigator.pushReplacementNamed(
                                        context, 'home');
                                  } else {
                                    // Show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please type "CONFIRM" in uppercase to confirm.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text("Confirm"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : TextButton(
                    child: Text("PROMOTE"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDemoteConfirmationDialog(BuildContext context, User user,
      String communityId, UserService userService) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Demote User"),
          content: Text("Are you sure you want to demote this user?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("DEMOTE"),
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showKickConfirmationDialog(BuildContext context, User user,
      String communityId, UserService userService) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kick User"),
          content: Text("Are you sure you want to kick this user?"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("KICK"),
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

class CommunityManageScreen extends StatefulWidget {
  final Community community;

  const CommunityManageScreen({Key? key, required this.community})
      : super(key: key);

  @override
  _CommunityManageScreenState createState() => _CommunityManageScreenState();
}

class _CommunityManageScreenState extends State<CommunityManageScreen> {
  bool viewMembersTapped = false;

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
                      title: Text('Change Community Info',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCommunityScreen(
                              user: userService.user,
                              communityToEdit: communityService.chosenCommunity,
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
                                        await communityService.getMyCommunities(
                                            userService.user.id);
                                        await userService
                                            .findUserById(userService.user.id);
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