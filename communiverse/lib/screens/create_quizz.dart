import 'dart:io';

import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/utils.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateQuizzScreen extends StatefulWidget {
  final User user;

  const CreateQuizzScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CreateQuizzScreenState createState() => _CreateQuizzScreenState();
}

class _CreateQuizzScreenState extends State<CreateQuizzScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _communityController = TextEditingController();
  final List<Question> _questions = [];
  String? _selectedImage;
  Post createdPost = Post.empty();
  String selectedCommunityName =
      'Choose Community'; // Variable dentro del estado del widget

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final postService = Provider.of<PostService>(context);
    final userService = Provider.of<UserService>(context);
    final userLoginRequestService =
        Provider.of<UserLoginRequestService>(context);
    final communityService = Provider.of<CommunityService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 50, bottom: 10, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Text(
                        "Create Quizz",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CommunityDropdown(
                        communities: communityService.myCommunities,
                        communityController: _communityController)
                  ],
                ),
                SizedBox(height: 16),
                descriptionField(),
                SizedBox(height: 32),
                imageSelector(),
                SizedBox(height: 7),
                addQuestion(context),
                SizedBox(height: 10),
                questionList(),
                SizedBox(height: 20),
                createQuizz(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row addQuestion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Questions',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(229, 171, 255, 1),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestionScreen(
                  onQuestionAdded: (question) {
                    setState(() {
                      _questions.add(question);
                    });
                  },
                ),
              ),
            );
          },
          child: Text('Add Question'),
        ),
      ],
    );
  }

  ElevatedButton createQuizz(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(165, 91, 194, 1),
      ),
      onPressed: _questions.isEmpty ||
              selectedCommunityName == 'Choose Community'
          ? null
          : () async {
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
              createdPost.quizz.questions = _questions;
              createdPost.authorId = widget.user.id;
              Map<String, dynamic> postData = createdPost.toJson();
              await postService.postPost(postData);
              postService.currentPostPage = 0;
              await postService.findMyPostsPaged(widget.user.id);
              Navigator.pop(
                  context); // Cierra el diálogo emergente cuando la publicación se ha realizado correctamente
              Navigator.pop(context);
            },
      child: Text('Create Quizz'),
    );
  }

  Widget questionList() {
    return SizedBox(
      height: 200, // Altura deseada para la caja
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: _questions.map((question) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Options: ${question.options.join(', ')}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              'Correct Answer: ${question.correctAnswer}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _questions.remove(question);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

/*
  TextFormField nameField() {
    return TextFormField(
      onChanged: (value) {
        createdPost.quizz.name = value;
      },
      controller: _nameController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
*/

  Container descriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black),
      ),
      child: TextFormField(
        onChanged: (value) {
          createdPost.quizz.description = value;
        },
        controller: _descriptionController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Description',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
        maxLines: 3,
        maxLength: 130, // Permitir hasta 5 líneas
      ),
    );
  }

  Container communitySelector(List<Community> communities) {
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
            selectedCommunityName = newValue.name;
            createdPost.communityId = newValue.id;
            setState(() {});
          }
        },
        items:
            communities.map<DropdownMenuItem<Community>>((Community community) {
          return DropdownMenuItem<Community>(
            value: community,
            child: Text(community
                .name), // Suponiendo que el nombre de la comunidad está en la propiedad 'name'
          );
        }).toList(),
        hint: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  8.0), // Agrega un pequeño espacio a la izquierda del texto
          child: Text(
            selectedCommunityName,
            style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(165, 91, 194, 1)), // Color del texto
          ),
        ),
        dropdownColor: Colors.white, // Color de fondo del menú desplegable
        underline: Container(), // Elimina la línea inferior del ComboBox
        icon: Icon(Icons.keyboard_arrow_down,
            color: Color.fromRGBO(165, 91, 194, 1)),
        menuMaxHeight: 160,
      ),
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
            createdPost.photos.add(Utils.fileToBase64(File(image.path)));
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
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.add_photo_alternate,
                size: 50,
              ),
      ),
    );
  }
}
