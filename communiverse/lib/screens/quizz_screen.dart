import 'package:communiverse/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/models.dart';
import 'package:communiverse/widgets/widgets.dart';

class QuizScreen extends StatefulWidget {
  final Quizz quiz;
  final Post post;
  const QuizScreen({Key? key, required this.quiz, required this.post})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<String?> responses = []; // Lista para guardar las respuestas
  bool isAnswered = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    responses = List.generate(
      widget.quiz.questions
          .length, // Longitud de la lista igual al número de preguntas
      (index) => null, // Valor nulo para cada pregunta
    );
  }

  void nextQuestion() {
    setState(() {
      responses[currentQuestionIndex] =
          selectedOption; // Guardar la respuesta seleccionada
      isAnswered = false;
      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = responses[
            currentQuestionIndex]; // Recuperar la respuesta seleccionada para la siguiente pregunta
      } else {
        // Handle end of quiz
        // For example, navigate to the summary screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizSummary(
              responses: responses,
              quizz: widget.quiz,
              post: widget.post,
            ),
          ),
        );
      }
    });
  }

  void previousQuestion() {
    setState(() {
      responses[currentQuestionIndex] =
          selectedOption; // Guardar la respuesta seleccionada
      isAnswered = false;
      selectedOption = responses[currentQuestionIndex -
          1]; // Establecer la opción seleccionada para la pregunta anterior
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

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
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(46, 30, 47, 1),
          ),
          child: Stack(
            children: [
              superiorBackground(size),
              questionOnDisplay(size, currentQuestion),
              options(size, currentQuestion),
              backButton(),
              nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Positioned nextButton() {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: currentQuestionIndex == widget.quiz.questions.length - 1
          ? ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color.fromRGBO(
                        164, 47, 193, 1.0); // Fondo transparente
                  },
                ),
              ),
              onPressed: () {
                if (!isAnswered) {
                  nextQuestion();
                }
              },
              child: Text("Finish quiz", style: TextStyle(color: Colors.white)))
          : Container(
              width: 40, // Ajusta el ancho del botón
              height: 40, // Ajusta la altura del botón
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromRGBO(164, 47, 193, 1.0), // Color del borde
                  width: 1, // Ancho del borde
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (!isAnswered) {
                    nextQuestion();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.transparent; // Fondo transparente
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                child: Icon(Icons.arrow_forward,
                    color: Color.fromRGBO(
                        164, 47, 193, 1.0)), // Color de la flecha
              ),
            ),
    );
  }

  Positioned backButton() {
    return Positioned(
      bottom: 8.0,
      left: 8.0,
      child: Container(
        width: 40, // Ajusta el ancho del botón
        height: 40, // Ajusta la altura del botón
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromRGBO(164, 47, 193, 1.0), // Color del borde
            width: 1, // Ancho del borde
          ),
        ),
        child: currentQuestionIndex == 0 // Verifica si es la primera pregunta
            ? SizedBox() // Si es la primera pregunta, muestra un espacio vacío
            : ElevatedButton(
                onPressed: () {
                  if (!isAnswered && currentQuestionIndex != 0) {
                    // Solo permite retroceder si no se ha respondido y no es la primera pregunta
                    previousQuestion();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Color.fromRGBO(
                          46, 30, 47, 0); // Fondo transparente
                    },
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                child: Icon(Icons.arrow_back,
                    color: Color.fromRGBO(
                        164, 47, 193, 1.0)), // Color de la flecha
              ),
      ),
    );
  }

  Positioned options(Size size, Question currentQuestion) {
    return Positioned(
      top: size.height * 0.35,
      left: 20,
      right: 20,
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
                      return Color.fromRGBO(222, 139, 255, 1);
                    }
                    return selectedOption == option
                        ? Color.fromRGBO(222, 139, 255, 1)
                        : Colors.white;
                  },
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 48.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(164, 47, 193, 1.0),
                    ),
                  ),
                ),
              ),
              child: Text(option, style: TextStyle(color: Colors.black)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Positioned questionOnDisplay(Size size, Question currentQuestion) {
    return Positioned(
      top: size.height * 0.1,
      left: 20,
      right: 20,
      child: Container(
        height: size.height * 0.2,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(164, 47, 193, 1.0),
              ),
            ),
            SizedBox(height: 30),
            Text(
              currentQuestion.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
