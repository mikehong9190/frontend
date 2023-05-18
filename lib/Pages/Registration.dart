// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import 'package:frontend/Pages/Initiative.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../model/responses.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/RegistrationPages.dart';
// import 'package:frontend/Pages/login.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:im_stepper/main.dart';
import 'package:http/http.dart';
import '../components/RadioButton.dart';

import '../store.dart';
// import 'package:fluttertoast/fluttertoast.dart';

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
  late var schoolId = '';
  late var isLoading = false;
  late var isAgreed = false;
  late var isPasswordHidden = true;
  late var isConfirmPasswordHidden = true;
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final schoolNameController = TextEditingController();
  final schoolDistrictController = TextEditingController();
  late var isPasswordValid = false;
  late var arePasswordsEqual = false;
  late var message = '';
  InitiativeTypeEnum? _initiativeTypeEnum;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.read<User>().userId;
    if (userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SystemNavigator.pop();
      });
    }
  }

  SingingCharacter? _character = SingingCharacter.jefferson;

  Future<List<SingleDistrictResponse>> getDistrict(String query) async {
    try {
      final queryParameters = {"text": query};

      final response =
          await get(Uri.https(apiHost, '/v1/school/search', queryParameters));
      if (response.statusCode == 200) {
        final jsonData = DistrictResponse.fromJson(jsonDecode(response.body));
        return jsonData.data;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  void changeState(value) => setState(() {
        _initiativeTypeEnum = value;
      });
  void checkPasswordVisiblity() async {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

// <<<<<<< ui-changes
// =======
  void goToLogin() {
    Navigator.pushNamed(context, "/login");
  }

// >>>>>>> dev
  void checkConfirmPasswordVisibility() async {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }

  Future<List<School>> getSchools(String query) async {
    try {
      final queryParameters = {
        "text": "",
        "district": schoolDistrictController
      };
      final response =
          await get(Uri.https(apiHost, '/v1/school/search', queryParameters));
      if (response.statusCode == 200) {
        final jsonData = SchoolList.fromJson(jsonDecode(response.body));
        return jsonData.data;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      return [];
    }
  }

  void checkEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await post(Uri.https(apiHost, '/v1/validate-email'),
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
      } else {
        setState(() {
          statusCode = response.statusCode;
          message = jsonData.message;
        });
      }
    } catch (err, stackTrace) {
      print(StackTrace);
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void clickOnSuggestion(value, controller) {
    setState(() {
      controller.text = value;
    });
  }

  void clickOnSchool(id, name, controller) {
    setState(() {
      controller.text = name;
      schoolId = id;
    });
  }

  void verifyOtp() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await post(Uri.https(apiHost, '/v1/verify-otp'),
          body: jsonEncode({
            "emailId": emailController.text,
            "requestType": "email",
            "otp": otpController.text
          }));
      if (response.statusCode == 200) {
        setState(() {
          message = "";
          statusCode = 0;
          currentStep += 1;
        });
      } else {
        setState(() {
          message = "Invalid OTP";
          statusCode = response.statusCode;
        });
      }
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
    otpController.text.isEmpty ? checkEmail() : verifyOtp();
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
      // print(ggAuth?.idToken);
      // print(ggAuth?.accessToken);
      while (token!.isNotEmpty) {
        int initLength = (token.length >= 500 ? 500 : token.length);
        print(token.substring(0, initLength));
        int endLength = token.length;
        token = token.substring(initLength, endLength);
      }
    } catch (error) {
      print(error);
    }
  }

  void registerUser() async {
    try {
      print("Hello");
      setState(() {
        isLoading = true;
      });
      late var payload = {
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "emailId": emailController.text,
        "password": passwordController.text,
        "createSchool": schoolId.isEmpty ? "true" : "false"
      };

      if (schoolId.isEmpty) {
        payload["schoolName"] = schoolNameController.text;
        payload["districtName"] = schoolDistrictController.text;
      } else {
        payload["schoolId"] = schoolId;
      }
      final response = await post(Uri.https(apiHost, '/v1/signup'),
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        final jsonData =
            RegisteredUserResponse.fromJson(jsonDecode(response.body));
        context.read<User>().setUserDetails(
            userId: jsonData.data.id,
            emailId: emailController.text,
            message: jsonData.message);
        Navigator.pushNamedAndRemoveUntil(
            context, '/app', (Route<dynamic> route) => false);
        // Navigator.pushNamed(context, '/app', arguments: {
        //   "UserId": jsonData.data.id,
        //   "message": jsonData.message
        // });
      }
      print(jsonDecode(response.body));
    } catch (error, stackTrace) {
      print(stackTrace);

      print(error);
    } finally {
      setState(() {
        schoolId = '';
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
            title: const Text(''),
            content: FirstPageWidget(
                emailController,
                checkEmailAndChangeStep,
                message,
                statusCode,
                otpController,
                isLoading,
                isOtpSend,
                goToLogin),
            isActive: currentStep >= 0),
        Step(
            title: const Text(''),
            content: SecondPageWidget(
                passwordController,
                confirmPasswordController,
                checkPasswordAndChangeStep,
                message,
                isPasswordValid,
                arePasswordsEqual,
                isPasswordHidden,
                isConfirmPasswordHidden,
                checkPasswordVisiblity,
                checkConfirmPasswordVisibility),
            isActive: currentStep >= 1),
        Step(
            title: const Text(''),
            content: ThirdPageWidget(
                firstNameController,
                lastNameController,
                schoolDistrictController,
                schoolNameController,
                registerUser,
                isLoading,
                getDistrict,
                getSchools,
                clickOnSuggestion,
                clickOnSchool),
            isActive: currentStep >= 2),
        Step(
            title: const Text(''),
            content: SetupInitiativeWidget(_initiativeTypeEnum, changeState)),
      ];

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(
        () {},
      );
    });
    passwordController.addListener(() {
      setState(
        () {
          if (passwordController.text.length >= 8 &&
              passwordController.text.length < 20) {
            setState(() {
              isPasswordValid = true;
            });
          } else {
            setState(() {
              isPasswordValid = false;
            });
          }

          if (passwordController.text.isNotEmpty &&
              passwordController.text == confirmPasswordController.text) {
            setState(() {
              arePasswordsEqual = true;
            });
          } else {
            setState(() {
              arePasswordsEqual = false;
            });
          }
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
          } else {
            setState(() {
              arePasswordsEqual = false;
            });
          }
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
                colorScheme: const ColorScheme.light(primary: Colors.black)),
            child: Padding(
                padding: const EdgeInsets.only(top: 20),
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
