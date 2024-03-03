import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailorusernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          SizedBox(height: size.height * 0.01),
          emailorusername(),
          SizedBox(height: size.height * 0.03),
          password(),
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
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: false);
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
      onChanged: (value) => userLoginRequestService.emailOrUsername = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email or Username required';
        }
        return null;
      },
    );
  }

  TextFormField password() {
    final userLoginRequestService = Provider.of<UserLoginRequestService>(context, listen: false);
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
      onChanged: (value) => userLoginRequestService.password = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password required';
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
        final userService =
        Provider.of<UserService>(context, listen: true);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
        final communityService = Provider.of<CommunityService>(context, listen: true);
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
          Map<String, dynamic> credentials = userLoginRequestService.toJson();
          print(credentials);
          try {
            await userLoginRequestService.signIn(credentials);
            await userService.findUserById(UserLoginRequestService.userLoginRequest.id);
            await communityService.getTop5Communities();
            Navigator.of(context).pushNamed('home');
          } catch (error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Login Error"),
                  content: Text(
                      error.toString()),
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
      child: Text('Login'),
    );
  }
}
