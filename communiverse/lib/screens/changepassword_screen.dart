import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communiverse/services/user_apiauth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _confirmChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Password Change'),
        content: Text(
            'Are you sure you want to change your password? This will log you out.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _changePassword();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userLoginRequestService =
          Provider.of<UserLoginRequestService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final currentPassword = _currentPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New passwords do not match')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print("user for change pass: ${userService.user.email}");
      final data = {
        'emailOrUsername': userService.user.email,
        'password': currentPassword,
        "newPassword": newPassword
      };

      try {
        await userLoginRequestService.editPassword(
            '${userService.user.email}', data);
        // Replace 'user_id' with the actual user ID
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        ); // Go back to the previous screen
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your current password and your new password.',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50.0),
                buildPasswordTextField(
                  controller: _currentPasswordController,
                  hintText: 'Current password',
                  isObscure: !_isCurrentPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                buildPasswordTextField(
                  controller: _newPasswordController,
                  hintText: 'New password',
                  isObscure: !_isNewPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                buildPasswordTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  isObscure: !_isConfirmPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmChangePassword,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Confirm'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(165, 91, 194, 1)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
        ),
      ),
      style: TextStyle(color: Colors.white),
      obscureText: isObscure,
      validator: validator,
    );
  }

  InputDecoration decoration(String title) {
    return InputDecoration(
      prefixIcon: Icon(Icons.lock, color: Colors.white),
      hintText: "$title",
      hintStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
