import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> answers;
  const QuestionWidget(
      {super.key, required this.question, required this.answers});

  @override
  Widget build(context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          Text(question,
              style: const TextStyle(fontFamily: 'Urbanist', fontSize: 24)),
          const SizedBox(height: 30),
          ...answers
              .map(
                (e) => Text(e),
              )
              .toList()
        ]);
  }
}
