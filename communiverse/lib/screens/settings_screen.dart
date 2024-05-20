import 'package:communiverse/screens/changepassword_screen.dart';
import 'package:communiverse/services/google_signIn_api.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          if (!userService
              .user.isGoogle) // Verifica si no es un usuario de Google

            Divider(
              color: Colors.white,
            ),
          if (!userService
              .user.isGoogle) // Verifica si no es un usuario de Google
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.lock, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
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
                          // Realizar logout
                          userService.clearData();
                          GoogleSignInApi.logout();
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
