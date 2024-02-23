 import 'package:flutter/material.dart';

Row formDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10), // Adjust spacing between text and dividers
        Text(
          'Or continue with',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
      ],
    );
  }