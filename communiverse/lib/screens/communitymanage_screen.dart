import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/services/services.dart';
import 'package:provider/provider.dart';

class CommunityManageScreen extends StatelessWidget {
  final Community community;

  const CommunityManageScreen({Key? key, required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Manage Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Divider(),
            if (userService.user.moderatedCommunities
                .contains(community.id)) ...[
              ListTile(
                title:
                    Text('View Members', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navegar a la pantalla de miembros de la comunidad
                },
              ),
              Divider(),
              ListTile(
                title: Text('Leave Community',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Dejar la comunidad
                },
              ),
            ] else if (userService.user.createdCommunities
                .contains(community.id)) ...[
              ListTile(
                title:
                    Text('View Members', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navegar a la pantalla de miembros de la comunidad
                },
              ),
              Divider(),
              ListTile(
                title: Text('Change Community Info',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navegar a la pantalla de cambio de información de la comunidad
                },
              ),
              Divider(),
              ListTile(
                title: Text('Eliminate Community',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Eliminar la comunidad
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
