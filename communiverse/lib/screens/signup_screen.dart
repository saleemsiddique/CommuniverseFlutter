import 'dart:math';

import 'package:communiverse/services/google_signIn_api.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(86, 73, 87, 1),
      body: SingleChildScrollView(
        // Wrap your form with SingleChildScrollView
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
                  Provider.of<UserService>(context, listen: false).lastName =
                      value;
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
                botonGoogleSignUp(context)
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
        if (value == null || value.isEmpty || value.length < 3) {
          return 'Valid $field required (min 3 characters)';
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
        // Validar el formato del correo electrónico utilizando una expresión regular
        String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
        RegExp regExp = RegExp(emailRegex);
        if (!regExp.hasMatch(value)) {
          return 'Invalid email format';
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
        if (value == null || value.isEmpty || value.length < 3) {
          return 'Valid username required (min 3 characters)';
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
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Valid password required (min 6 characters)';
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
    final userService = Provider.of<UserService>(context, listen: true);
    final postService = Provider.of<PostService>(context, listen: false);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
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
      onPressed: _isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                Map<String, dynamic> credentials = userService.toJson();
                Map<String, dynamic> credentialsLogIn = {
                  "emailOrUsername": "${_emailController.text}",
                  "password": "${_passwordController.text}",
                  "google": false
                };
                print(credentials);
                print(credentialsLogIn);
                try {
                  await userService.signUp(credentials);
                  await userLoginRequestService.signIn(credentialsLogIn);
                  await userService.findUserById(
                      UserLoginRequestService.userLoginRequest.id);
                  await postService.findMyPostsPaged(userService.user.id);
                  await postService.findMyRePostsPaged(userService.user.id);
                  await communityService.getTop5Communities();
                  await communityService.getMyCommunities(userService.user.id);
                  _isLoading = false;
                  Navigator.of(context).pushReplacementNamed('home');
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
                              setState(() {
                                _isLoading = false;
                              });
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
      child: _isLoading ? Text('Signing up...') : Text('Sign up'),
    );
  }

  Widget botonGoogleSignUp(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 124, 122, 122),
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 0,
        color: Colors.white,
        onPressed: () => _isLoading ? null : signIn(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/googleLogo.png'),
              width: 30,
            ),
            SizedBox(
              width: 10,
            ),
            _isLoading
                ? Text("Signing up...")
                : Text(
                    'Sign up with Google',
                    style: TextStyle(
                      color: Colors.black, // You can adjust the color as needed
                      fontSize: 16, // You can adjust the font size as needed
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    setState(() {
      _isLoading = true;
    });

    final userService = Provider.of<UserService>(context, listen: false);
    final postService = Provider.of<PostService>(context, listen: false);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: false);
    final communityService =
        Provider.of<CommunityService>(context, listen: false);

    final user = await GoogleSignInApi.login();
    if (user == null) {
      print("Google Login failed");
      setState(() {
        _isLoading = false;
      });
    } else {
      print("Google: $user");
      print("Google: ${user.toString()}");

      String email = user.email ?? '';
      String name = user.displayName?.split(' ')[0] ?? '';
      String lastName = user.displayName?.split(' ')[1] ?? '';

      String username = generateUsername(name, lastName);

      Map<String, dynamic> credentials = {
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": "contrasenya",
        "username": username,
        "isGoogle": true
      };
      Map<String, dynamic> credentialsLogIn = {
        "emailOrUsername": email,
        "password": 'contrasenya',
        "google": true
      };
      print(credentials);
      print(credentialsLogIn);
      try {
        await userService.signUp(credentials);
        await userLoginRequestService.signIn(credentialsLogIn);
        await userService
            .findUserById(UserLoginRequestService.userLoginRequest.id);
        await postService.findMyPostsPaged(userService.user.id);
        await postService.findMyRePostsPaged(userService.user.id);
        await communityService.getTop5Communities();
        await communityService.getMyCommunities(userService.user.id);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('home');
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sign Up Error"),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    GoogleSignInApi.logout();
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Text("Accept"),
                ),
              ],
            );
          },
        );
      }
    }
    return user;
  }

  String generateUsername(String name, String lastName) {
    String firstPart = name.length >= 3 ? name.substring(0, 3) : name;
    String lastPart =
        lastName.length >= 3 ? lastName.substring(0, 3) : lastName;
    String randomString = getRandomString(5);
    return '$firstPart${lastPart}_$randomString';
  }

  String getRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
}
