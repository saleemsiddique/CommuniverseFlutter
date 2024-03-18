import 'dart:io';

import 'package:communiverse/models/models.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/utils.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateCommunityScreen extends StatefulWidget {
  final User user;

  const CreateCommunityScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _privacySetting = 'Public';
  String? _selectedImage;
  Community createdCommunity = Community.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              imageSelector(),
              SizedBox(height: 40),
              TextFormField(
                controller: _communityNameController,
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: Colors.white),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                    child: Icon(Icons.groups), // _myIcon is a 48px-wide widget.
                  ),
                  hintText: 'Community Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  createdCommunity.name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter a valid community name (minimum 3 characters)';
                  }
                  return null;
                },
                maxLength: 30,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: Colors.white),
                  hintText: 'Description (Max 200 characters)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
                maxLength: 200,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  createdCommunity.description = value;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Privacy Settings',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor:
                          Colors.grey[400], // Color del radio no seleccionado
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'Public',
                          groupValue: _privacySetting,
                          onChanged: (value) {
                            setState(() {
                              _privacySetting = value!;
                              createdCommunity.privacy = value.toUpperCase();
                            });
                          },
                        ),
                        Text('Public'),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor:
                          Colors.grey[400], // Color del radio no seleccionado
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'Private',
                          groupValue: _privacySetting,
                          onChanged: (value) {
                            setState(() {
                              _privacySetting = value!;
                              createdCommunity.privacy = value.toUpperCase();
                            });
                          },
                        ),
                        Text('Private'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              createCommunity(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton createCommunity() {
    final communityService =
        Provider.of<CommunityService>(context, listen: true);
    final userService = Provider.of<UserService>(context, listen: true);
    final userLoginRequest =
        Provider.of<UserLoginRequestService>(context, listen: true);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(165, 91, 194, 1),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Evita que se cierre la ventana emergente haciendo clic fuera de ella
            builder: (BuildContext context) {
              return AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(), // Indicador de progreso
                    SizedBox(
                        width: 20), // Espacio entre el indicador y el texto
                    Text(
                        "Posting..."), // Texto que indica que se está publicando
                  ],
                ),
              );
            },
          );
          try {
            createdCommunity.userCreatorId = userService.user.id;
            Map<String, dynamic> communityData = createdCommunity.toJson();
            print("PostData: $communityData");
            await communityService.postCommunity(communityData);
            userService.user.createdCommunities
                .add(communityService.createdCommunity.id);
            print("Prev: ${userService.user}");
            Map<String, dynamic> userData = userService.user.toJson();
            print("PouserService: ${userService.user}");
            await userLoginRequest.editUserCommunities(
                userService.user.id, userData);
            communityService.getMyCommunities(userService.user.id);
            Navigator.pop(context);
            Navigator.pop(context);
          } catch (error) {
            Navigator.pop(
                context); // Cierra el diálogo emergente si hay un error
            errorTokenExpired(context);
          }
        }
      },
      child: Text('Create'),
    );
  }

  InkWell imageSelector() {
    return InkWell(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _selectedImage = image.path;
            createdCommunity.photo = Utils.fileToBase64(File(image.path));
          });
        }
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black),
        ),
        child: _selectedImage != null
            ? Image.file(
                File(_selectedImage!),
                fit: BoxFit.fill,
              )
            : Icon(
                Icons.add_photo_alternate,
                size: 50,
              ),
      ),
    );
  }
}
