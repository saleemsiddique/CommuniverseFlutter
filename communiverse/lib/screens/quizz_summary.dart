import 'package:flutter/material.dart';

class QuizSummary extends StatelessWidget {
  final List<bool> results;

  const QuizSummary({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int correctCount = results.where((result) => result).length;
    int totalCount = results.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resultado: $correctCount de $totalCount respuestas correctas',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle retry
              },
              child: Text('Retry'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle navigate back to community
              },
              child: Text('Back to Community'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle navigate back to home
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}