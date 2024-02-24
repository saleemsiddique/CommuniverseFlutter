import 'package:communiverse/widgets/password_textbox.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          names("First name", Icon(Icons.person), _firstnameController),
          SizedBox(height: size.height * 0.02),
          names("Last name", Icon(Icons.person), _lastnameController),
          SizedBox(height: size.height * 0.02),
          email(),
          SizedBox(height: size.height * 0.02),
          PasswordFormField(),
          SizedBox(height: size.height * 0.02),
          ConfirmPasswordFormField(
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
          ),
          SizedBox(height: size.height * 0.02),
          username(),
          SizedBox(height: size.height * 0.02),
          signupButton(context),
          SizedBox(height: size.height * 0.03),
          formDivider(),
          SizedBox(height: size.height * 0.02),
          botonGoogle(context)
        ],
      ),
    );
  }

  TextFormField names(
      String field, Icon icon, TextEditingController controllerField) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controllerField,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: field,
        filled: true, // Set filled to true
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust border radius
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$field required';
        }
        return null;
      },
    );
  }

  TextFormField username() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _usernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "Username",
        filled: true, // Set filled to true
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust border radius
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username required';
        }
        return null;
      },
    );
  }

  ElevatedButton signupButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
            Size(double.infinity, 50)), // Set button size
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromRGBO(165, 91, 194, 1), // Set button background color
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Formulario válido. Datos enviados.'),
            ),
          );
        }
      },
      child: Text('Sign up'),
    );
  }
}
