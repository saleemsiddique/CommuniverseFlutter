import 'package:communiverse/widgets/password_textbox.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailorusernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          emailorusername(),
          SizedBox(height: size.height * 0.03),
          PasswordFormField(),
          SizedBox(height: size.height * 0.00015),
          forgetPassword(),
          SizedBox(height: size.height * 0.02),
          loginButton(context),
          SizedBox(height: size.height * 0.03),
          formDivider(),
          SizedBox(height: size.height * 0.03),
          botonGoogle(context),
          SizedBox(height: size.height * 0.03),
          endFormText(),
        ],
      ),
    );
  }

  TextFormField emailorusername() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _emailorusernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "Email Address or Username",
        filled: true, // Set filled to true
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust border radius
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email or Username required';
        }
        return null;
      },
    );
  }

  Align forgetPassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          // Action for forgot password
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ElevatedButton loginButton(BuildContext context) {
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
      child: Text('Login'),
    );
  }
}
