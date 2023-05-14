import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../components/Button.dart';
import '../components/TextField.dart';
// import '../components/Button.dart';

class LoginResponse {
  final String message;
  final idResponse data;
  const LoginResponse({required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        message: json['message'], data: idResponse.fromJson(json["data"]));
  }
}

class idResponse {
  final String id;
  final String token;

  const idResponse({required this.id, required this.token});

  factory idResponse.fromJson(Map<String, dynamic> json) => idResponse(
        id: json["id"],
        token: json["token"],
      );
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isPasswordValid = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // put your logic from initState here
  }

  void login() async {
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/login'),
          body: jsonEncode({
            "emailId": emailController.text,
            "password": passwordController.text
          }));
      print(response.body);
      final jsonData = LoginResponse.fromJson(jsonDecode(response.body));
      print(jsonData.data.id);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app", arguments: {
          "UserId": jsonData.data.id,
          "message": jsonData.message
        });
      }
    } catch (error) {
      print(error);
    }
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

  void changePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Login to Swiirl",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Login",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(132, 143, 172, 1)))),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              TextFieldWidget("Your Email", emailController, false, null, true),
              PasswordFieldWidget(
                  "Password",
                  passwordController,
                  isPasswordHidden,
                  isPasswordValid,
                  true,
                  changePasswordVisibility),
              const SizedBox(
                height: 20,
              ),
              ButtonTheme(
                child: SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(54, 189, 151, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                      onPressed: () {
                        login();
                        // print(controller1.text);
                        // print(controller2.text);
                      },
                      child: const Text("Next"),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 30,
                    child: Text('OR'),
                  )),
              const OAuthButtonWidget(
                  content: "Continue with Google", iconUrl: "Google"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child:
                      Image.asset("assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
                ),
              ),
            ],
          ),
        ));
  }
}
