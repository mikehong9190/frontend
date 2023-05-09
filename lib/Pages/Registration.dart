import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/RegistrationPages.dart';
import 'package:frontend/Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/main.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class EmailVerificationResponse {
  final String message;
  const EmailVerificationResponse({required this.message});

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(message: json['message']);
  }
}

enum SingingCharacter { lafayette, jefferson }

class _RegistrationWidgetState extends State<RegistrationWidget> {
  late var currentStep = 0;
  final currentStage = "firstPage";
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final schoolNameController = TextEditingController();
  final schoolDistrictController = TextEditingController();
  late var message = '';
  SingingCharacter? _character = SingingCharacter.jefferson;

  void checkEmail() async {
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/validate-email'),
          body: jsonEncode({"emailId": emailController.text}));
      final jsonData = EmailVerificationResponse.fromJson(jsonDecode(response.body));
      if (jsonData.message == "") setState(() {
        currentStep += 1;
      });
      else setState(() {
        message = "Email Already Exists";
      });
    } catch (err) {
      print(err);
    }
  }

  void checkEmailAndChangeStep() {
    checkEmail();
  }

  void checkPasswordAndChangeStep() {
    setState(() {
      currentStep += 1;
    });
    
  }

  void checkEmptyAndChangeStep() {
    setState(() {
      currentStep += 1;
    });
  }

  List<Step> getSteps() => [
        Step(
            title: Text(''),
            content: FirstPageWidget(emailController, checkEmailAndChangeStep,message),
            isActive: currentStep >= 0),
        Step(
            title: Text(''),
            content: SecondPageWidget(passwordController,
                confirmPasswordController, checkPasswordAndChangeStep),
            isActive: currentStep >= 1),
        Step(
            title: Text(''),
            content: ThirdPageWidget(nameController, schoolDistrictController,
                schoolNameController, checkEmptyAndChangeStep),
            isActive: currentStep >= 2),
      ];

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(
        () {},
      );
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        body: Theme(
            data: ThemeData(
                primarySwatch: Colors.blue,
                colorScheme: ColorScheme.light(primary: Colors.black)),
            child: Stepper(
              controlsBuilder: (context,details) {
                return Container();
              },
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: currentStep,
            )));
  }
}
