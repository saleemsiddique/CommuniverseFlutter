import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Color.fromRGBO(86, 73, 87, 1),
      body: SingleChildScrollView( // Wrap your form with SingleChildScrollView
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                names("Name", _nameController, (value) {
                  Provider.of<UserService>(context, listen: false).name = value;
                }),
                SizedBox(height: size.height * 0.02),
                names("Last Name", _lastNameController, (value) {
                  Provider.of<UserService>(context, listen: false).lastName = value;
                }),
                SizedBox(height: size.height * 0.02),
                email(),
                SizedBox(height: size.height * 0.02),
                password(),
                SizedBox(height: size.height * 0.02),
                confirmPasswordFormField(),
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
          ),
        ),
      ),
    );
  }

  TextFormField names(String field, TextEditingController controllerField,
      Function(String) onChanged) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controllerField,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: field,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$field required';
        }
        return null;
      },
    );
  }

  TextFormField email() {
    final userService = Provider.of<UserService>(context, listen: false);
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
      onChanged: (value) => userService.email = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email required';
        }
        return null;
      },
    );
  }

  TextFormField username() {
    final userService = Provider.of<UserService>(context, listen: false);
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
      onChanged: (value) => userService.username = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username required';
        }
        return null;
      },
    );
  }

  TextFormField password() {
    final userService = Provider.of<UserService>(context, listen: false);
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          child: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
      obscureText: _isPasswordVisible,
      onChanged: (value) => userService.password = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password required';
        }
        return null;
      },
    );
  }

  TextFormField confirmPasswordFormField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: Icon(Icons.lock),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          child: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
      obscureText: _isPasswordVisible,
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  ElevatedButton signupButton(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
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
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Map<String, dynamic> credentials = userService.toJson();
          print(credentials);
          try {
            await userService.signUp(credentials);
            Navigator.of(context).pushNamed('home');
          } catch (error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Sign Up Error"),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Accept"),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      child: Text('Sign up'),
    );
  }
}
