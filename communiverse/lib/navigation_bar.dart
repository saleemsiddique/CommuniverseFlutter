import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Stack(
          alignment: AlignmentDirectional.center,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    _onItemTapped(0);
                  },
                  color: _selectedIndex == 0 ? Colors.white : Colors.black,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    _onItemTapped(1);
                  },
                  color: _selectedIndex == 1 ? Colors.white : Colors.black,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
