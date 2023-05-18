import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../components/Button.dart';
import '../components/TextField.dart';
// import '../components/Button.dart';
import '../store.dart';
import '../constants.dart';

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

  const idResponse(
      {required this.id, required this.token,});

  factory idResponse.fromJson(Map<String, dynamic> json) => idResponse(
      id: json["id"],
      token: json["token"]);
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
      final response = await post(Uri.https(apiHost,'/v1/login'),
          body: jsonEncode({
            "emailId": emailController.text,
            "password": passwordController.text
          }));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = LoginResponse.fromJson(jsonDecode(response.body));
        context.read<User>().setUserDetails(
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
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Column(
                children: const [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Login to Swiirl",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
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
                    style: const TextStyle(color: Colors.red),
                  )),
              const SizedBox(
                height: 10,
              ),
              ButtonTheme(
                child: SizedBox(
                    height: 50,
                    width: double.infinity,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ?"),
                  TextButton(
                    onPressed: goToRegistration,
                    child: const Text(
                      'Signin',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 20),
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
