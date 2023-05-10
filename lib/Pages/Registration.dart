import '../model/responses.dart';

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

enum SingingCharacter { lafayette, jefferson }

class _RegistrationWidgetState extends State<RegistrationWidget> {
  late var currentStep = 0;
  late var statusCode = 0;
  late var districts = [];
  final currentStage = "firstPage";
  late var isLoading = false;
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final schoolNameController = TextEditingController();
  final schoolDistrictController = TextEditingController();
  late var message = '';
  SingingCharacter? _character = SingingCharacter.jefferson;

  void getDistrict() async {
    try {
      final response = await get(
        Uri.parse(
            'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/school/search?text='),
      );
      final jsonData = DistrictResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        setState(() {
          districts = jsonData.data;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void checkEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/validate-email'),
          body: jsonEncode(
              {"emailId": emailController.text, "requestType": "email"}));
      final jsonData =
          EmailVerificationResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        setState(() {
          statusCode = response.statusCode;
          message = jsonData.message;
        });
      } else
        setState(() {
          statusCode = response.statusCode;
          message = "Email Already Exists";
        });
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyOtp() async {
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/verify-otp'),
          body: jsonEncode({
            "emailId": emailController.text,
            "requestType": "email",
            "otp": otpController.text
          }));
      if (response.statusCode == 200)
        setState(() {
          message = "";
          statusCode = 0;
          currentStep += 1;
        });
      else
        setState(() {
          message = "Invalid OTP";
          statusCode = response.statusCode;
        });
      otpController.text = '';
    } catch (error) {
      print(error);
    }
  }

  void checkEmailAndChangeStep() {
    otpController.text.length == 0 ? checkEmail() : verifyOtp();
  }

  void checkPasswordAndChangeStep() {
    if (passwordController.text != confirmPasswordController.text) {
      return setState(() {
        message = 'Password not matching';
      });
    }
    setState(() {
      currentStep += 1;
    });
  }

  void registerUser() async {
    final body = jsonEncode({
      "firstname": nameController.text.split(' ')[0],
      "lastname": nameController.text.split(' ')[1],
      "password": passwordController.text,
      "emailId": emailController.text,
      "districtName": schoolDistrictController.text,
      "schoolName": schoolNameController.text,
      "createSchool": true,
    });
    print (body);
    final response = await post(
        Uri.parse(
            'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/signup'),
        body: body);

    print (jsonDecode(response.body));
  }

  void checkEmptyAndChangeStep() {
    setState(() {
      currentStep += 1;
    });
  }

  List<Step> getSteps() => [
        Step(
            title: Text(''),
            content: FirstPageWidget(emailController, checkEmailAndChangeStep,
                message, statusCode, otpController, isLoading),
            isActive: currentStep >= 0),
        Step(
            title: Text(''),
            content: SecondPageWidget(passwordController,
                confirmPasswordController, checkPasswordAndChangeStep, message),
            isActive: currentStep >= 1),
        Step(
            title: Text(''),
            content: ThirdPageWidget(nameController, schoolDistrictController,
                schoolNameController, registerUser),
            isActive: currentStep >= 2),
      ];

  @override
  void initState() {
    getDistrict();
    print("Page Mounted");
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
              controlsBuilder: (context, details) {
                return Container();
              },
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: currentStep,
            )));
  }
}
