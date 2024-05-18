import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController descriptionController;
  final TextEditingController usernameController;
  final Map<String, dynamic> Function() getEditedUserData;

  ProfileEditScreen({
    required this.user,
    required this.firstNameController,
    required this.lastNameController,
    required this.descriptionController,
    required this.usernameController,
    required this.getEditedUserData,
  });

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _usernameController;
  late TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.name);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _descriptionController = TextEditingController(text: widget.user.biography);
    _usernameController = TextEditingController(text: widget.user.username);
    _levelController =
        TextEditingController(text: widget.user.userStats.level.toString());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descriptionController.dispose();
    _usernameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(165, 91, 194, 0.2),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 100, right: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('First Name', _firstNameController),
                  _buildDivider(),
                  _buildField('Last Name', _lastNameController),
                  _buildDivider(),
                  _buildField('Biography', _descriptionController),
                  _buildDivider(),
                  _buildField('Username', _usernameController),
                  _buildDivider(),
                  _buildField('Level', _levelController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    // Variables para almacenar las restricciones según el campo
    int minLength = 3;
    int maxLength = 20;
    String hint = 'Enter $label';
    TextInputType keyboardType = TextInputType.text;

    // Aplicar restricciones según el campo
    switch (label) {
      case 'Username':
        maxLength = 20;
        hint = 'Enter username';
        break;
      case 'Biography':
        maxLength = 100;
        hint = 'Enter biography';
        keyboardType = TextInputType.multiline;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          readOnly:
              label == 'Level', // Para hacer el campo de nivel no editable
          style: TextStyle(
            color: Color.fromRGBO(222, 139, 255, 1),
            fontSize: 16,
          ),
          maxLines: label == 'Biography'
              ? 5
              : 1, // Permitir múltiples líneas para la biografía
          keyboardType:
              keyboardType, // Definir el tipo de teclado según el campo
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Color.fromRGBO(222, 139, 255, 1),
              fontSize: 16,
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              switch (label) {
                case 'First Name':
                  widget.firstNameController.text = newValue;
                  break;
                case 'Last Name':
                  widget.lastNameController.text = newValue;
                  break;
                case 'Biography':
                  // Limitar la cantidad de saltos de línea en la biografía a un máximo de 5
                  final lines = RegExp(r'\n').allMatches(newValue).length;
                  if (lines <= 5) {
                    widget.descriptionController.text = newValue;
                  } else {
                    // Si hay más de 5 saltos de línea, no actualizar el valor
                    // Esto evitará que se agreguen más líneas de las permitidas
                    widget.descriptionController.text =
                        newValue.substring(0, newValue.lastIndexOf('\n'));
                  }
                  break;
                case 'Username':
                  widget.usernameController.text = newValue;
                  break;
              }
            });
            widget.getEditedUserData();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            } else if (value.length < minLength) {
              return 'Minimum length is $minLength characters';
            } else if (value.length > maxLength) {
              return 'Maximum length is $maxLength characters';
            } else {
              // Verificar si hay más de 5 saltos de línea
              final lines = RegExp(r'\n').allMatches(value).length;
              if (lines >= 5) {
                return 'Maximum of 5 line breaks allowed';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: 3),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          height: 1.0,
          color: Colors.white,
        )
      ],
    );
  }
}
