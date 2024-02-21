import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const LoginForm({Key? key, required this.formKey}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formKey,
      child: ListView(
        children: <Widget>[
          email(),
          SizedBox(height: size.height * 0.03),
          password(),
          SizedBox(height: size.height * 0.0001),
          forgetPassword(),
          SizedBox(height: size.height * 0.02),
          loginButton(context),
          SizedBox(height: size.height * 0.03),
          formDivider(),
          SizedBox(height: size.height * 0.03),
          _botonGoogle(),
          SizedBox(height: size.height * 0.03),
          endFormText(),
        ],
      ),
    );
  }

  TextFormField email() {
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

  TextFormField password() {
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
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      ),
      obscureText: !_isPasswordVisible,
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
        if (widget.formKey.currentState!.validate()) {
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

  Row formDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10), // Adjust spacing between text and dividers
        Text(
          'Or continue with',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Center endFormText() {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        'By signing in with an account, you agree to enter the Communiverse.',
        style: TextStyle(
          color: Colors.white, // Puedes ajustar el color según sea necesario
          fontSize:
              12, // Puedes ajustar el tamaño de fuente según sea necesario
        ),
      ),
    );
  }

  Widget _botonGoogle() {
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
}
