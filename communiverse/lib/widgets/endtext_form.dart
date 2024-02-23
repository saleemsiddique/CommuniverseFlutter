  import 'package:flutter/material.dart';

Center endFormText() {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        'By signing in with an account, you agree to enter the Communiverse.',
        style: TextStyle(
          color: Colors.white, // Puedes ajustar el color según sea necesario
          fontSize:
              12, // Puedes ajustar el tamaño de fuente según sea necesario
        ),
      ),
    );
  }