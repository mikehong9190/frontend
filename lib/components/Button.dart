import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../model/responses.dart';
import 'dart:io' show Platform;

class OAuthButtonWidget extends StatelessWidget {
  final String content;
  final String iconUrl;

  const OAuthButtonWidget(
      {super.key, required this.content, required this.iconUrl});

  googleLogin(context) async {
    // print("googleLogin method Called");
    if (Platform.isAndroid) {
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
        // while (token!.isNotEmpty) {
        //   int initLength = (token.length >= 500 ? 500 : token.length);
        //   print(token.substring(0, initLength));
        //   int endLength = token.length;
        //   token = token.substring(initLength, endLength);
        // }
        final response = await post(
            Uri.parse(
                'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/signup'),
            body: jsonEncode({"idToken": token}));
        final jsonData = Welcome.fromJson(jsonDecode(response.body));
        // if (response.statusCode ==)
        // print(response.body);
        if (response.statusCode == 200 &&
            jsonData.message == 'Account created successfully!') {
          Navigator.pushNamed(context, "/google-auth-school",
              arguments: {"id": jsonData.data.id, "message": jsonData.message});
        } else {
          Navigator.pushNamed(context, "/app",
              arguments: {"UserId": jsonData.data.id, "message": "Logged in"});
        }
      } catch (error) {
        print(error);
      }
    } else if (Platform.isIOS) {
      final _googleSignIn = GoogleSignIn(
        clientId:
            "566550290119-ke7vuiphb33c5jjl3168klvj9jum2sr5.apps.googleusercontent.com",
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
        // while (token!.isNotEmpty) {
        //   int initLength = (token.length >= 500 ? 500 : token.length);
        //   print(token.substring(0, initLength));
        //   int endLength = token.length;
        //   token = token.substring(initLength, endLength);
        // }
        final response = await post(
            Uri.parse(
                'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/signup'),
            body: jsonEncode({"idToken": token}));
        final jsonData = Welcome.fromJson(jsonDecode(response.body));
        // if (response.statusCode ==)
        // print(response.body);
        if (response.statusCode == 200 &&
            jsonData.message == 'Account created successfully!') {
          Navigator.pushNamed(context, "/google-auth-school",
              arguments: {"id": jsonData.data.id, "message": jsonData.message});
        } else {
          Navigator.pushNamed(context, "/app",
              arguments: {"UserId": jsonData.data.id, "message": "Logged in"});
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  build(context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
              child: Row(
                children: [
                  Expanded(child: Container()),
                  SvgPicture.asset(
                    "assets/svg/$iconUrl.svg",
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                  ),
                  Expanded(child: Container())
                ],
              )
              // Text(
              //   content,
              //   style: TextStyle(color: Colors.black),
              // )
              ,
              onPressed: () {
                googleLogin(context);
              }),
        )
      ],
    );
  }
}
