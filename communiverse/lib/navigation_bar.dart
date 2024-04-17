import 'package:communiverse/extras/pager.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  bool _showMenu = false;

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  Future<void> _onItemTapped(int index) async {
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    final postService = Provider.of<PostService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    if (index == 0) {
    } else if (index == 1) {
      postService.currentPostPage = 0;
      postService.currentRepostPage = 0;
      await userService.searchOtherUsers(userService.user.username);
      await Future.wait([
        postService.findMyPostsPaged(userService.searchedUsersList[index].id),
        postService.findMyRePostsPaged(userService.searchedUsersList[index].id),
        communityService
            .getMyCommunities(userService.searchedUsersList[index].id)
      ]);
    } // Si no probar con intentar meter todas las funciones en una y llamar el notifyListener ahi, quitando el notifyListener de las funciones individuales
    setState(() {
      _selectedIndex = index;
      _showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          ProfileScreen(
            username: UserLoginRequestService.userLoginRequest.username,
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Color.fromRGBO(61, 22, 72, 1),
              ),
            ),
            HexagonButton(
              showMenu: _showMenu,
              toggleMenu: _toggleMenu,
            ),
            if (_showMenu) MenuWidget(showMenu: _showMenu),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    color: _selectedIndex == 0
                        ? Color.fromRGBO(229, 171, 255, 1)
                        : Colors.grey,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    color: _selectedIndex == 1
                        ? Color.fromRGBO(229, 171, 255, 1)
                        : Colors.grey,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
