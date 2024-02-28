import 'package:flutter/material.dart';
import 'package:communiverse/screens/screens.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 1; // Índice inicial, que representa el ProfileScreen

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: IndexedStack(
      index: _selectedIndex,
      children: [
        HomeScreen(),
        Container(), // Este contenedor está vacío porque el índice 1 representa el ProfileScreen
        ProfileScreen(),
      ],
    ),
    bottomNavigationBar: Padding(
      padding: EdgeInsets.symmetric(horizontal: 60), // Espacio en los lados
      child: Stack(alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none, // Para permitir que los widgets salgan fuera del área del Stack
        children: <Widget>[
          Container(
            height: 75, // Altura deseada del BottomAppBar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), // Bordes redondeados superiores
                topRight: Radius.circular(20),
              ),
              color: Color.fromRGBO(61, 22, 72, 1), // Color de fondo deseado
            ),
          ),
          Positioned(
            bottom: 50, // Hace que el botón sobresalga 30 unidades por encima del Container
              child: Transform.rotate(
                angle: 45 * 3.14 / 180, // Rotación para alinear el hexágono
                child: Container(
                  width: 50, // Ancho del hexágono
                  height: 50, // Altura del hexágono
                  decoration: BoxDecoration(
                    color:Color.fromRGBO(79, 40, 87, 1), // Color de fondo del hexágono
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        // Acción del botón central
                      },
                      color: Colors.black, // Color del icono
                    ),
                  ),
                ),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(0); // Cambia al HomeScreen
                },
                color: Colors.black, // Color del icono
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  _onItemTapped(2); // Cambia al ProfileScreen
                },
                color: Colors.black, // Color del icono
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
