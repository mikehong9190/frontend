import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GettingStartedWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
            child: Stack(children: [
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Image.asset("assets/images/Mockup.jpg"),
          SizedBox(
            height: 50,
          ),
          Text(
            "Take a picture and rewrite the story",
            style: TextStyle(fontSize: 24, fontFamily: "Bold/Type@24"),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Art to Digital Collectibles in a single click",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registration');
                },
                icon: ClipOval(
                    child: Container(
                        width: 100,
                        height: 100,
                        color: Color.fromRGBO(54, 189, 151, 1),
                        child: Text('Start'),
                        alignment: Alignment.center))),
          )
        ],
      ))
    ])));
  }
}