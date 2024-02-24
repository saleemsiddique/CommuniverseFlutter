import 'package:flutter/material.dart';

class ConfirmPasswordFormField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ConfirmPasswordFormField({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  _ConfirmPasswordFormFieldState createState() => _ConfirmPasswordFormFieldState();
}

class _ConfirmPasswordFormFieldState extends State<ConfirmPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.confirmPasswordController,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: true,
      validator: (value) {
        if (value != widget.passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
