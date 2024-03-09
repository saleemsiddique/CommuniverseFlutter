import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    final userService = Provider.of<UserService>(context, listen: true);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Change Language',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.language, color: Colors.white),
            onTap: () {
              // Acción al seleccionar "Change Language"
            },
          ),
          Divider(
            color: Colors.white,
          ),
          ListTile(
            title: Text(
              'Change Password',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.lock, color: Colors.white),
            onTap: () {
              // Acción al seleccionar "Change Password"
            },
          ),
          Divider(
            color: Colors.white,
          ),
          ListTile(
            title: Text(
              'Log out',
              style: TextStyle(color: Colors.red),
            ),
            leading: Icon(Icons.logout, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Limpiar datos y realizar logout
                          postService.clearData();
                          communityService.clearData();
                          userService.clearData();
                          userLoginRequestService.clearData();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
