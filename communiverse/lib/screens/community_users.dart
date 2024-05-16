import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
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
    final postService = Provider.of<PostService>(context, listen: true);
    bool isCreator =
        widget.user.createdCommunities.contains(widget.community.id);
    bool isModerator =
        widget.user.moderatedCommunities.contains(widget.community.id);
    bool isMember = widget.user.memberCommunities.contains(widget.community.id);

    bool imHim = userService.user.id == widget.user.id;

    bool iAmCreator =
        userService.user.createdCommunities.contains(widget.community.id);

    return GestureDetector(
      onTap: () async {
        postService.currentPostPage = 0;
        postService.currentRepostPage = 0;
        await userService.findOtherUserById(widget.user.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              username: userService.searchedUser.username,
              fromPost: true,
              fromSearch: false,
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              widget.user.photo), // Asigna la imagen del perfil como avatar
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.username,
              style: TextStyle(
                  color: Colors.white, overflow: TextOverflow.ellipsis),
            ),
            Text(
              '${widget.user.name} ${widget.user.lastName}',
              style: TextStyle(
                  color: Colors.white, overflow: TextOverflow.ellipsis),
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
                        await userService.promoteInCommunity(
                            widget.community.id,
                            widget.user.id,
                            userService.user.id);
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
                          context,
                          widget.user,
                          widget.community.id,
                          userService);
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
                  color: !imHim && !isCreator && isModerator || isMember
                      ? Colors.red
                      : Colors.grey),
              onPressed: () async {
                int? dias = await _showKickDurationDialog(context);
                if (dias != null) {
                  bool? kick = await _showKickConfirmationDialog(
                      context, widget.user, widget.community.id, userService);
                  if (kick != null && kick) {
                    await userService.kickFromCommunity(
                        widget.community.id, widget.user.id, dias);
                    setState(() {
                      isKick = false;
                    });
                  }
                }
              },
            ),
          ],
        ),
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

Future<int?> _showKickDurationDialog(BuildContext context) async {
  final durations = {
    "Cancel": null,
    "1 day": 1,
    "1 week": 7,
    "1 month": 30,
    "1 year": 365,
    "Undefined": 9999,
  };

  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select the duration of the ban"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: durations.entries
              .map((entry) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(165, 91, 194, 1),
                      ),
                      onPressed: () {
                        Navigator.pop(context, entry.value);
                      },
                      child: Text(
                        entry.key,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    },
  );
}
