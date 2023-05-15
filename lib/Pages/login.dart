import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../components/Button.dart';
import '../components/TextField.dart';
// import '../components/Button.dart';
import '../store.dart';

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
  final String profilePicture;
  const idResponse({required this.id, required this.token,required this.profilePicture});

  factory idResponse.fromJson(Map<String, dynamic> json) => idResponse(
        id: json["id"],
        token: json["token"],
        profilePicture: json["profilePicture"]
      );
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String message = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordHidden = true;
  bool isPasswordValid = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // put your logic from initState here
  }

  bool buttonDisability() {
    return emailController.text.contains("@") &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      print("Runssss");
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/login'),
          body: jsonEncode({
            "emailId": emailController.text,
            "password": passwordController.text
          }));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = LoginResponse.fromJson(jsonDecode(response.body));
        context.read<User>().setUserDetails(
            profilePicture: jsonData.data.profilePicture,
            userId: jsonData.data.id,
            emailId: emailController.text,
            message: jsonData.message);
        Navigator.pushNamedAndRemoveUntil(
            context, '/app', (Route<dynamic> route) => false);
        // Navigator.pushNamed(context, "/app", arguments: {
        //   "UserId": jsonData.data.id,
        //   "message": jsonData.message
        // });
      } else {
        print("dsdkjfnsdf");
        setState(() {
          message = 'Either Email OR Password is incorrect';
        });
      }
      print("aaaaaaaaaaaa");
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
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

  void goToRegistration() {
    Navigator.pushNamed(context, "/registration");
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
              SizedBox(
                  height: 20,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(
                height: 10,
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
                      onPressed: buttonDisability()
                          ? () {
                              login();
                            }
                          : null,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Next"),
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
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 80, right: 50),
                      child: Row(
                        children: [
                          Text("Already have an account? "),
                          TextButton(
                              onPressed: goToRegistration,
                              child: Text(
                                'Signin',
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ))),
              Expanded(
                child: const SizedBox(),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                        "assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
                  )),
            ],
          ),
        ));
  }
}
