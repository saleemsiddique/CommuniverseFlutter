import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class CommunityBannedProfileItem extends StatefulWidget {
  final User user;
  final Community community;

  CommunityBannedProfileItem({required this.user, required this.community});

  @override
  State<CommunityBannedProfileItem> createState() =>
      _CommunityBannedProfileItemState();
}

class _CommunityBannedProfileItemState
    extends State<CommunityBannedProfileItem> {
  @override
  Widget build(BuildContext context) {
  final userService = Provider.of<UserService>(context, listen: true);
  final communityService = Provider.of<CommunityService>(context, listen: true);

  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(widget.user.photo),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los elementos a la izquierda y derecha
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.username,
              style: TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${widget.user.name} ${widget.user.lastName}',
              style: TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            onPrimary: Colors.black, // Color del texto del botón
          ),
          onPressed: () {
            communityService.unbanUser(widget.community.id, widget.user.id);
          },
          child: Text('Unban'),
        ),
      ],
    ),
  );
}
}
