import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GettingStartedWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
        body: FractionallySizedBox(
            alignment: Alignment.topCenter,
            child: Container(
                child: Stack(children: [
              Center(
                  child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Image.asset(
                    "assets/images/Mockup.jpg",
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        child: Text(
                      "Take a picture and",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        child: Text(
                      "rewrite the story",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Art to Digital Collectibles in a single click",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registration');
                        },
                        icon: Container(
                          // decoration: BoxDecoration(boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 40,
                          //       offset: Offset(0, 10),
                          //       color: Colors.black)
                          // ]),
                          child: ClipOval(
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  color: Color.fromRGBO(116, 231, 199, 1),
                                  child: Text(
                                    'Start',
                                  ),
                                  alignment: Alignment.center)),
                        )),
                  )
                ],
              ))
            ]))));
  }
}
