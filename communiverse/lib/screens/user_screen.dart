import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;
  final List<String> _tabs = ['Posts', 'Reposts', 'Communities'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Parte superior izquierda: foto de perfil y nombre de usuario
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('URL_DE_LA_IMAGEN'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Nombre de Usuario',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre completo',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('Descripción'),
                            Text('Nivel'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Parte superior derecha: información adicional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Followers',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('123'), // Aquí iría el número de seguidores
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Followed',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('456'), // Aquí iría el número de seguidos
                  ],
                ),
              ],
            ),
            // Widget con pestañas para los diferentes contenidos
            DefaultTabController(
              length: _tabs.length, // Número de pestañas
              child: Column(
                children: [
                  TabBar(
                    tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  Container(
                    height: 200, // Altura del contenido de la pestaña
                    child: TabBarView(
                      children: [
                        // Contenido de la pestaña Posts
                        Center(
                          child: Text('Contenido de Posts'),
                        ),
                        // Contenido de la pestaña Reposts
                        Center(
                          child: Text('Contenido de Reposts'),
                        ),
                        // Contenido de la pestaña Communities
                        Center(
                          child: Text('Contenido de Communities'),
                        ),
                      ],
                    ),
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
