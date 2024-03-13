import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear un post'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Lógica para enviar el post
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: '¿Qué estás pensando?',
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Permitir múltiples líneas
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Lógica para agregar imagen
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Agregar foto'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Lógica para agregar ubicación
                  },
                  icon: Icon(Icons.location_on),
                  label: Text('Agregar ubicación'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}