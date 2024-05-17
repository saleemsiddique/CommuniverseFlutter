import 'package:communiverse/services/google_signIn_api.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      onPressed: () => Navigator.pushNamed(context, 'home'),
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
          Text(
            'Login with Google',
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