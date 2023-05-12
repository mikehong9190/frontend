import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../components/TextField.dart';
import '../components/Button.dart';

class LoginResponse {
  final String message;
  final Object data;
  const LoginResponse({required this.message,required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(message: json['message'],data : json['data']);
  }
}

class idResponse {
  final String id;
  final String token;

  const idResponse({required this.id, required this.token});
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/login'),
          body: jsonEncode({
            "emailId": emailController.text,
            "password": passwordController.text
          }));

      final jsonData = LoginResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: jsonData.message,
          backgroundColor: Color.fromRGBO(54, 189, 151, 1),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void getLogin() {
    login();
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(
        () {},
      );
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text(
            "Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Login",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          SizedBox(height: 30),
          TextFieldWidget("email", emailController, false,null,true),
          TextFieldWidget("password", passwordController, false,null,true),
          SizedBox(
            height: 60,
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  child: Text("Next"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)))),
                  onPressed: () {
                    getLogin();
                  },
                )),
          ),
        ],
      ),
    ));
  }
}
