import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OAuthButtonWidget extends StatelessWidget {
  final String content;
  final String iconUrl;

  OAuthButtonWidget({super.key, required this.content, required this.iconUrl});

  @override
  Widget build(context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
            width: 350,
            height: 50,
            child: OutlinedButton(
                child: Text(
                  content,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  print("Pringf ::");
                })),
      ],
    );
  }
}