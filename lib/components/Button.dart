import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget OAuthButtonWidget(content, iconUrl) {
  return Column(
    children: [
      SizedBox(
        height: 30,
      ),
      SizedBox(
          width: 350,
          height: 50,
          child: OutlinedButton(
              child: Row(
                children: [
                  SizedBox (width: 50,),
                  SvgPicture.asset("assets/svg/" + iconUrl + ".svg",),
                  SizedBox (width: 20,),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                  )
                ],
              )
              // Text(
              //   content,
              //   style: TextStyle(color: Colors.black),
              // )
              ,
              onPressed: () {
                print("Pringf ::");
              })),
    ],
  );
}
