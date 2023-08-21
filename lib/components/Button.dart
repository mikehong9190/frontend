// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import '../model/responses.dart';
import '../store.dart';

class OAuthButtonWidget extends StatefulWidget {
  final String content;
  final String iconUrl;
  @override
  State<OAuthButtonWidget> createState() => _OAuthButtonWidgetState();
  const OAuthButtonWidget(
      {super.key, required this.content, required this.iconUrl});
}

class _OAuthButtonWidgetState extends State<OAuthButtonWidget> {
  bool isLoading = false;

  googleLogin(context) async {
    dynamic googleSignIn;

    // log("googleLogin method Called");
    try {
      if (Platform.isAndroid) {
        googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            "https://www.googleapis.com/auth/userinfo.profile",
            "openid"
          ],
        );
      } else {
        googleSignIn = GoogleSignIn(
          clientId:
              "566550290119-ke7vuiphb33c5jjl3168klvj9jum2sr5.apps.googleusercontent.com",
          scopes: [
            'email',
            "https://www.googleapis.com/auth/userinfo.profile",
            "openid"
          ],
        );
      }
      final result = await googleSignIn.signIn();
      final ggAuth = await result?.authentication;
      var token = ggAuth?.idToken;

      final response = await post(Uri.https(apiHost, '/v1/auth/signup'),
          body: jsonEncode({"idToken": token, "platform": "android"}));
      final jsonData = Welcome.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200 &&
          jsonData.message == 'Account created successfully!') {
        context.read<User>().setUserDetails(
            userId: jsonData.data.id,
            emailId: '',
            message: "created account using google");
        Navigator.pushNamed(context, "/google-auth-school");
      } else {
        context.read<User>().setUserDetails(
            userId: jsonData.data.id,
            emailId: '',
            message: "logged in using google");
        Navigator.pushNamed(context, "/app");
      }
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
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
                    "assets/svg/${widget.iconUrl}.svg",
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          widget.content,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                  Expanded(child: Container())
                ],
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                dynamic googleSignIn;
                try {
                  if (Platform.isAndroid) {
                    googleSignIn = GoogleSignIn(
                      scopes: [
                        'email',
                        "https://www.googleapis.com/auth/userinfo.profile",
                        "openid"
                      ],
                    );
                  } else {
                    googleSignIn = GoogleSignIn(
                      clientId:
                          "566550290119-ke7vuiphb33c5jjl3168klvj9jum2sr5.apps.googleusercontent.com",
                      scopes: [
                        'email',
                        "https://www.googleapis.com/auth/userinfo.profile",
                        "openid"
                      ],
                    );
                  }
                  final result = await googleSignIn.signIn();
                  final ggAuth = await result?.authentication;
                  var token = ggAuth?.idToken;

                  final response = await post(
                      Uri.https(apiHost, '/v1/auth/signup'),
                      body: jsonEncode({
                        "idToken": token,
                        "platform": Platform.isAndroid ? "android" : "ios"
                      }));
                  if (response.statusCode == 200) {
                    final jsonData =
                        Welcome.fromJson(jsonDecode(response.body));
                    if (jsonData.message == 'Account created successfully!') {
                      context.read<User>().setUserDetails(
                          userId: jsonData.data.id,
                          token: jsonData.data.token,
                          emailId: '',
                          message: "created account using google");
                      Navigator.pushNamed(context, "/google-auth-school");
                    } else {
                      context.read<User>().setUserDetails(
                          userId: jsonData.data.id,
                          token: jsonData.data.token,
                          emailId: '',
                          message: "logged in using google");
                      Navigator.pushNamed(context, "/app");
                    }
                  }
                } catch (error, stackTrace) {
                  log(stackTrace.toString());
                  log(error.toString());
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              }),
        )
      ],
    );
  }
}
