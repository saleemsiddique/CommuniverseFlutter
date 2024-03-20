import 'package:communiverse/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';

class QuizScreen extends StatefulWidget {
  final Quizz quiz;

  const QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedOption;
  List<bool> results = [];
  bool isAnswered = false;
  bool isCorrect = false;

  void checkAnswer() {
    setState(() {
      isAnswered = true;
      isCorrect = widget.quiz.questions[currentQuestionIndex].correctAnswer ==
          selectedOption;
      results.add(isCorrect);
    });
  }

  void nextQuestion() {
    setState(() {
      isAnswered = false;
      isCorrect = false;
      selectedOption = null;
      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Handle end of quiz
        // For example, navigate to another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizSummary(results: results),
          ),
        );
      }
    });
  }

  @override
  @override
Widget build(BuildContext context) {
  Question currentQuestion = widget.quiz.questions[currentQuestionIndex];
  final Size size = MediaQuery.of(context).size;

  return Scaffold(
    body: Center(
      child: Container(
        height: size.height * 0.8,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              // Fondo semi-transparente
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              // Contenedor para la pregunta
              Positioned(
                top: size.height * 0.1,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Opciones
              Positioned(
                top: size.height * 0.35, // Ajusta la posición de las opciones
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: currentQuestion.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedOption = option;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color.fromRGBO(222, 139, 255,
                                    1); // Cambia el color al presionar
                              }
                              return selectedOption == option
                                  ? Color.fromRGBO(222, 139, 255, 1)
                                  : Colors.white;
                            },
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity,
                                48.0), // Define la altura del botón
                          ),
                        ),
                        child: Text(option, style: TextStyle(color: Colors.black)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Botones de navegación
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Implementa la funcionalidad para retroceder
                  },
                  child: Text('Atrás'),
                ),
              ),
              Positioned(
                bottom: 8.0,
                right: 8.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Implementa la funcionalidad para avanzar
                  },
                  child: Text('Adelante'),
                ),
              ),
              // Respuesta correcta/incorrecta
              if (isAnswered)
                Positioned(
                  top: size.height * 0.25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      isCorrect ? 'Correcto' : 'Incorrecto',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Botón de enviar
              Positioned(
                bottom: size.height * 0.1,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: selectedOption != null && !isAnswered ? checkAnswer : null,
                  child: Text('Enviar'),
                ),
              ),
              // Botón de siguiente pregunta
              Positioned(
                bottom: size.height * 0.05,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: isAnswered ? nextQuestion : null,
                  child: Text('Siguiente Pregunta'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
