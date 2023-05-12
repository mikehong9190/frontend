import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Opacity(
                        opacity: 1,
                        child: Image.asset("assets/images/cover.png",
                            fit: BoxFit.cover))),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Image.asset("assets/images/swiirl.png"),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/getStarted");
                              },
                              icon: SizedBox(
                                height: 100,
                                width: 100,
                                child:
                                    SvgPicture.asset("assets/svg/Next.svg"),
                              )),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Align(alignment: Alignment.bottomCenter,child:
                        Text('Artfully Funding the Future',
                            style: TextStyle(color: Colors.white)),
),
                      ]),
                )
              ],
            )));
  }
}