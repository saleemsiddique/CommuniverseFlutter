import 'package:communiverse/models/models.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  final Function(Question) onQuestionAdded;

  const AddQuestionScreen({Key? key, required this.onQuestionAdded})
      : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final _optionControllers =
      List.generate(4, (index) => TextEditingController());
  List<String> _options = ['', '', '', ''];
  int _correctIndex = -1;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: size.width * 0.8,
              child: ListView(
                padding: EdgeInsets.only(top: size.height * 0.1),
                children: [
                  Center(
                    child: Text(
                      "Create Question",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  SizedBox(height: 16),
                  question(),
                  SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Responses',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  options(),
                  SizedBox(height: 16),
                  addQuestion(context),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Row addQuestion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            List<String> options = _optionControllers
                .map((controller) => controller.text.trim())
                .toList();
            if (_questionController.text.isNotEmpty &&
                options.every((option) => option.isNotEmpty) &&
                _correctIndex != -1) {
              final newQuestion = Question(
                question: _questionController.text,
                options: options,
                correctAnswer: options[_correctIndex],
              );
              widget.onQuestionAdded(newQuestion);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Please enter a question, all options, and choose a correct answer before adding.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(229, 171, 255, 1),
          ),
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Column options() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _optionControllers
          .asMap()
          .entries
          .map(
            (entry) => GestureDetector(
              onTap: () {
                setState(() {
                  _correctIndex = entry.key;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color:
                      _correctIndex == entry.key ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          TextFormField(
                            maxLength: 28,
                            controller: _optionControllers[entry.key],
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: 'Option ${entry.key + 1}',
                                border: InputBorder.none,
                                counterText: ""),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _correctIndex = entry.key;
                                });
                              },
                              child: Container(
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: _correctIndex == entry.key
                                    ? Icon(Icons.check,
                                        color: Colors.black, size: 16)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  question() {
    return TextFormField(
      maxLength: 60,
      controller: _questionController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Question',
        filled: true,
        fillColor: Colors.white,
        counterStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
