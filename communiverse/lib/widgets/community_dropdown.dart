import 'package:flutter/material.dart';
import 'package:communiverse/models/community.dart';

typedef void CommunityChangedCallback(Community selectedCommunity);

class CommunityDropdown extends StatefulWidget {
  final List<Community> communities;
  final TextEditingController communityController;
  final CommunityChangedCallback onChanged;

  const CommunityDropdown({
    Key? key,
    required this.communities,
    required this.communityController,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CommunityDropdownState createState() => _CommunityDropdownState();
}
class _CommunityDropdownState extends State<CommunityDropdown> {
  String selectedCommunityName = 'Choose Community';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 150, // Ancho deseado
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Bordes redondos
        color: Colors.white, // Fondo blanco
      ),
      child: DropdownButton<Community>(
        onChanged: (Community? newValue) {
          if (newValue != null) {
            setState(() {
              selectedCommunityName = newValue.name;
              widget.communityController.text = newValue.id;
            });
            widget.onChanged(newValue); // Llama a la devolución de llamada
          }
        },
        items: [
          if (widget.communities.isNotEmpty)
            ...widget.communities.map<DropdownMenuItem<Community>>(
              (Community community) {
                return DropdownMenuItem<Community>(
                  value: community,
                  child: Text(
                    community.name,
                  ),
                );
              },
            ),
        ],
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              selectedCommunityName,
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(165, 91, 194, 1),
              ),
            ),
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Color.fromRGBO(165, 91, 194, 1),
        ),
        isExpanded: true,
        underline: Container(),
        menuMaxHeight: 175,
        elevation: widget.communities.isNotEmpty ? 8 : 0, // Aplicar elevación solo si hay elementos en el menú
        disabledHint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'No communities',
            style: TextStyle(fontSize: 14,
              color: Colors.grey, // Color del texto cuando está deshabilitado
            ),
          ),
        ),
        dropdownColor: Colors.white, // Color de fondo del menú desplegable
      ),
    );
  }
}
