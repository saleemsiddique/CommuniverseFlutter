import 'package:communiverse/services/user_apiauth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  ForgotPasswordScreen({this.initialEmail});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool isSent = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  void _sendNewPassword() async {
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context, listen: false);
    final email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await userLoginRequestService.forgotPassword(email);
      setState(() {
        isLoading = false;
        isSent = true;
      });
    } catch (error) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Forgot Password'),
      ),
      body: isSent
          ? Center(
              child: Text("Check your email: ${_emailController.text}"),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your email address to receive a new password.',
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                            color:
                                Colors.white), // Estilo del texto de sugerencia
                        filled: true, // Campo de texto rellenado
                        fillColor:
                            Colors.transparent, // Color de fondo del campo
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Radio del borde
                          borderSide: BorderSide(
                              color: Colors.white), // Color del borde
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Borde cuando no está seleccionado
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color:
                                  Colors.white), // Borde cuando está enfocado
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white), // Estilo del texto ingresado
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendNewPassword,
                        child: isLoading ? Text("Sending email...") : Text('Send New Password'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(165, 91, 194, 1)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0)
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
