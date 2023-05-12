import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> answers;
  const QuestionWidget(
      {super.key, required this.question, required this.answers});

  @override
  Widget build(context) {
    return Column(children: [
      SizedBox(height: 50),
      Text(question, style: TextStyle(fontFamily: 'Urbanist', fontSize: 24)),
      SizedBox(height: 30),
      ...answers
          .map(
            (e) => Text(e),
          )
          .toList()
    ]);
  }
}