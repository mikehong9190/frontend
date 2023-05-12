import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'dart:convert';
Widget OAuthButtonWidget(content, iconUrl) {
  googleLogin() async {
    print("googleLogin method Called");
    final _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        "https://www.googleapis.com/auth/userinfo.profile",
        "openid"
      ],
    );
    try {
      final result = await _googleSignIn.signIn();
      final ggAuth = await result?.authentication;
      print('ID TOKEN');
      var token = ggAuth?.idToken;
      while (token!.isNotEmpty) {
        int initLength = (token.length >= 500 ? 500 : token.length);
        print(token.substring(0, initLength));
        int endLength = token.length;
        token = token.substring(initLength, endLength);
      }
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/signup'),
          body: jsonEncode({
            "idToken" : token
          }));
      print (response.body);
      // if (response.statusCode == 200) 
    } catch (error) {
      print(error);
    }
  }

  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 350,
        height: 50,
        child: OutlinedButton(
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                SvgPicture.asset(
                  "assets/svg/" + iconUrl + ".svg",
                ),
                SizedBox(
                  width: 20,
                ),
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
            onPressed: googleLogin),
      )
    ],
  );
}
