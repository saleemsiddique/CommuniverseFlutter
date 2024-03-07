import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String _firstName = 'John';
  String _lastName = 'Doe';
  String _description =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vestibulum lacinia metus, vel malesuada metus auctor at.';
  String _username = 'johndoe';
  int _level = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(165, 91, 194, 0.2),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('First Name', _firstName),
                  _buildDivider(),
                  _buildField('Last Name', _lastName),
                  _buildDivider(),
                  _buildField('Description', _description),
                  _buildDivider(),
                  _buildField('Username', _username),
                  _buildDivider(),
                  _buildField('Level', _level.toString()),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white,),
                    onPressed: () {
                      // Acción al presionar el icono "x"
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.white,),
                    onPressed: () {
                      // Acción al presionar el icono "check"
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    TextEditingController _controller = TextEditingController(text: value);

    return GestureDetector(
      onTap: () {
        if (label != 'Level') {
          _controller.text =
              value; // Para asegurar que el valor inicial se muestre
        }
      },
      child: Column(
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
            controller: _controller,
            readOnly:
                label == 'Level', // Para hacer el campo de nivel no editable
            style: TextStyle(
              color: Color.fromRGBO(222, 139, 255, 1),
              fontSize: 16,
            ),
            maxLines: label == 'Description'
                ? 5
                : 1, // Para permitir múltiples líneas en Description
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  value, // Para que el valor actual se muestre en el campo
              hintStyle: TextStyle(
                color: Color.fromRGBO(222, 139, 255, 1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
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
