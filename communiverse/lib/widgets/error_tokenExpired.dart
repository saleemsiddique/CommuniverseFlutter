import 'package:flutter/material.dart';

Future<dynamic> errorTokenExpired(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text("This session has expired"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
