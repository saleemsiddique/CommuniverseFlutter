import 'package:communiverse/screens/user_screen.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/services/user_service.dart';
import 'package:provider/provider.dart'; // Importa el servicio de usuario

class UserProfileItem extends StatelessWidget {
  final String profilePic;
  final String username;
  final String fullname;

  UserProfileItem(
      {required this.username,
      required this.profilePic,
      required this.fullname});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage(profilePic), // Asigna la imagen del perfil como avatar
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            fullname,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                // Llama a la función de búsqueda cada vez que cambia el texto
                if (value.length >= 3) {
                  userService.searchUsersList(value);
                }
                if (value.length < 3) {
                  setState(() {
                    userService.searchedUsersList.clear();
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
                    _searchController.clear(); // Limpiar el campo de búsqueda
                    setState(() {
                      userService.searchedUsersList
                          .clear(); // Limpiar los resultados de búsqueda
                    });
                  },
                  color: Color.fromRGBO(222, 139, 255, 1), // Color del icono
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Cierra el teclado al presionar el botón
                FocusScope.of(context).unfocus();
                // La búsqueda se realiza automáticamente al escribir al menos 3 letras
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromRGBO(222, 139, 255, 1), // Color del botón
              ),
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userService.searchedUsersList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      postService.currentPostPage = 0;
                      postService.currentRepostPage = 0;
                      await userService.searchOtherUsers(
                          userService.searchedUsersList[index].username);
                      await Future.wait([
                        postService.findMyPostsPaged(
                            userService.searchedUsersList[index].id),
                        postService.findMyRePostsPaged(
                            userService.searchedUsersList[index].id),
                            communityService.getMyCommunities(
                          userService.searchedUsersList[index].id)
                      ]); // Si no probar con intentar meter todas las funciones en una y llamar el notifyListener ahi, quitando el notifyListener de las funciones individuales
                      // Realizar la navegación a la nueva pantalla cuando se seleccione un elemento
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              username: userService
                                  .searchedUsersList[index].username),
                        ),
                      );
                    },
                    child: UserProfileItem(
                      username: userService.searchedUsersList[index].username,
                      fullname:
                          "${userService.searchedUsersList[index].name} ${userService.searchedUsersList[index].lastName}",
                      profilePic: userService.searchedUsersList[index].photo,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
