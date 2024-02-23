import 'package:flutter/material.dart';

TextFormField email() {
  TextEditingController _emailController = TextEditingController();
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: _emailController,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.email),
      hintText: "Email Address",
      filled: true, // Set filled to true
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjust border radius
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Email required';
      }
      return null;
    },
  );
}
