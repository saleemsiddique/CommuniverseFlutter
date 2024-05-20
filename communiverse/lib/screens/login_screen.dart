import 'package:communiverse/screens/forgetPassword_screen.dart';
import 'package:communiverse/services/google_signIn_api.dart';
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
  final TextEditingController _emailorusernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isLoading = false;

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
          botonGoogleSignIn(context),
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
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: false);
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
          final emailOrUsername = _emailorusernameController.text;
          if (emailOrUsername.contains('@')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(
                  initialEmail: emailOrUsername,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(
                  initialEmail: "",
                ),
              ),
            );
          }
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
    final userService = Provider.of<UserService>(context, listen: true);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: true);
    final postService = Provider.of<PostService>(context, listen: false);

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
                Map<String, dynamic> credentials =
                    userLoginRequestService.toJson();
                print(credentials);
                try {
                  await userLoginRequestService.signIn(credentials);
                  await userService.findUserById(
                      UserLoginRequestService.userLoginRequest.id);
                  await postService.findMyPostsPaged(userService.user.id);
                  await postService.findMyRePostsPaged(userService.user.id);
                  await communityService.getTop5Communities();
                  await communityService.getMyCommunities(userService.user.id);
                  _isLoading = false;
                  Navigator.of(context).pushNamed('home');
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      _isLoading = false;
                      return AlertDialog(
                        title: Text("Login Error"),
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
      child: _isLoading ? Text('Logging into account...') : Text('Login'),
    );
  }

  Widget botonGoogleSignIn(BuildContext context) {
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
                ? Text('Logging into account...')
                : Text(
                    'Login with Google',
                    style: TextStyle(
                      color: Colors.black, // You can adjust the color as needed
                      fontSize: 16, // You can adjust the font size as needed
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final postService = Provider.of<PostService>(context, listen: false);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: false);
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    final user = await GoogleSignInApi.login();
    if (user == null) {
      print("Google Login failed");
      setState(() {
        _isLoading = false;
      });
    } else {
      print("Google: $user");
      print("Google: ${user.toString()}");
      Map<String, dynamic> credentialsLogIn = {
        "emailOrUsername": user.email ?? '',
        "password": 'contrasenya',
        "google": true
      };
      print(credentialsLogIn);
      try {
        await userLoginRequestService.signIn(credentialsLogIn);
        await userService
            .findUserById(UserLoginRequestService.userLoginRequest.id);
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
}
