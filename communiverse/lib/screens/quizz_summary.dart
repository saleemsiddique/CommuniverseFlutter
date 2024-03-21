import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

class QuizSummary extends StatelessWidget {
  final List<String?> responses;
  final Quizz quizz;
  final Post post;
  const QuizSummary(
      {Key? key,
      required this.responses,
      required this.quizz,
      required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height * 0.8,
          width: size.width * 0.8,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(46, 30, 47, 1),
          ),
          child: Stack(
            children: [
              superiorBackground(size),
              questionOnDisplay(size),
              options(size, context)
            ],
          ),
        ),
      ),
    );
  }

  questionOnDisplay(Size size) {
    int totalQuestions = quizz.questions.length;
    int correctCount = 0;

    // Itera sobre las preguntas del quizz y compara las respuestas
    for (int i = 0; i < totalQuestions; i++) {
      Question question = quizz.questions[i];
      String? response = responses[i];

      if (response == question.correctAnswer) {
        correctCount++;
      }
    }
    double percentage = (correctCount / totalQuestions) * 100;
    int incorrectCount = totalQuestions - correctCount;
    return Positioned(
      top: size.height * 0.15,
      left: 20,
      right: 20,
      child: Container(
        height: size.height * 0.2,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 20,
              right: 70,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$correctCount',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 30,
              child: Text(
                'Correct',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$incorrectCount',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 12,
              child: Text(
                'Wrong',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(164, 47, 193, 1.0),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${percentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(164, 47, 193, 1.0)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Text(
                'Completion',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Positioned(
              top: 0,
              right: 60,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(164, 47, 193, 1.0),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$totalQuestions',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(164, 47, 193, 1.0)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 45,
              child: Text(
                'Total',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned options(Size size, BuildContext context) {
    return Positioned(
      top: size.height * 0.5,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuizScreen(quiz: post.quizz, post: post)));
                },
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text('Try Again', style: TextStyle(color: Colors.white)),
              Text('', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "home");
                },
                icon: Icon(Icons.home, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text('Home', style: TextStyle(color: Colors.white)),
              Text('', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.group, color: Colors.white),
              ),
              SizedBox(height: 5),
              Column(
                children: [
                  Text('Back to', style: TextStyle(color: Colors.white)),
                  Text('Community', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
