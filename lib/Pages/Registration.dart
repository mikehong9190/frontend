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
  late var isOtpSend = false;
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
  late var isPasswordValid = false;
  late var arePasswordsEqual = false;
  late var message = '';

  SingingCharacter? _character = SingingCharacter.jefferson;

  getDistrict() async {
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
          isOtpSend = true;
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
      setState(() {
        isLoading = true;
      });
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
    } finally {
      setState(() {
        isLoading = false;
      });
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
    try {
      print("Hello");
      setState(() {
        isLoading = true;
      });
      final body = jsonEncode({
        "firstname": nameController.text.split(' ')[0],
        "lastname": nameController.text.split(' ')[1],
        "password": passwordController.text,
        "emailId": emailController.text,
        "districtName": schoolDistrictController.text,
        "schoolName": schoolNameController.text,
        "createSchool": true,
      });

      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/signup'),
          body: body);
      if (response.statusCode == 200) Navigator.pushNamed(context, '/app');
      print(jsonDecode(response.body));
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                message, statusCode, otpController, isLoading, isOtpSend),
            isActive: currentStep >= 0),
        Step(
            title: Text(''),
            content: SecondPageWidget(
                passwordController,
                confirmPasswordController,
                checkPasswordAndChangeStep,
                message,
                isPasswordValid,
                arePasswordsEqual),
            isActive: currentStep >= 1),
        Step(
            title: Text(''),
            content: ThirdPageWidget(nameController, schoolDistrictController,
                schoolNameController, registerUser, isLoading, getDistrict),
            isActive: currentStep >= 2),
      ];

  @override
  void initState() {
    getDistrict();
    super.initState();
    emailController.addListener(() {
      setState(
        () {},
      );
    });
    passwordController.addListener(() {
      print(RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)')
          .hasMatch(passwordController.text));
      setState(
        () {
          if (passwordController.text.length > 8 &&
              passwordController.text.length < 20) {
            setState(() {
              isPasswordValid = true;
            });
          } else
            setState(() {
              isPasswordValid = false;
            });

          if (passwordController.text.length > 0 &&
              passwordController.text == confirmPasswordController.text) {
            setState(() {
              arePasswordsEqual = true;
            });
          } else
            setState(() {
              arePasswordsEqual = false;
            });
        },
      );
    });
    confirmPasswordController.addListener(() {
      setState(
        () {
          if (passwordController.text == confirmPasswordController.text) {
            setState(() {
              arePasswordsEqual = true;
            });
          } else
            setState(() {
              arePasswordsEqual = false;
            });
        },
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
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Stepper(
                  controlsBuilder: (context, details) {
                    return Container();
                  },
                  type: StepperType.horizontal,
                  elevation: 0,
                  steps: getSteps(),
                  currentStep: currentStep,
                ))));
  }
}
