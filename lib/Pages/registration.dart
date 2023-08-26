// ignore_for_file: use_build_context_synchronously, unused_field, file_names

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../model/responses.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/registration_pages.dart';
import 'package:http/http.dart';
import '../components/radio_button.dart';

import '../store.dart';

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
  late var isRegisterButtonEnabled = false;
  late var message = '';
  InitiativeTypeEnum? _initiativeTypeEnum;
  String? errorMessage;

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
      log(error.toString());
      return [];
    }
  }

  void changeAgreed(abcd) async {
    setState(() {
      isAgreed = !isAgreed;
    });
  }

  void changeState(value) => setState(() {
        _initiativeTypeEnum = value;
      });
  void checkPasswordVisibility() async {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  void goToLogin() {
    Navigator.pushNamed(context, "/login");
  }

  void checkConfirmPasswordVisibility() async {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }

  Future<List<School>> getSchools(String query) async {
    try {
      final queryParameters = {
        "text": "",
        "district": schoolDistrictController.text
      };
      final response =
          await get(Uri.https(apiHost, '/v1/school/search', queryParameters));
      if (response.statusCode == 200) {
        final jsonData = SchoolList.fromJson(jsonDecode(response.body));
        return jsonData.data;
      } else {
        return [];
      }
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
      return [];
    }
  }

  void checkEmail() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await post(Uri.https(apiHost, '/v1/auth/validate-email'),
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
      log(stackTrace.toString());
      log(err.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void clickOnSuggestion(value, controller) {
    setState(() {
      schoolNameController.text = '';
      schoolId = '';
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
      final response = await post(Uri.https(apiHost, '/v1/auth/verify-otp'),
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
      log(error.toString());
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
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        "https://www.googleapis.com/auth/userinfo.profile",
        "openid"
      ],
    );
    try {
      final result = await googleSignIn.signIn();
      final ggAuth = await result?.authentication;
      var token = ggAuth?.idToken;

      while (token!.isNotEmpty) {
        int initLength = (token.length >= 500 ? 500 : token.length);
        log(token.substring(0, initLength));
        int endLength = token.length;
        token = token.substring(initLength, endLength);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  void registerUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      late var payload = {
        "firstname": firstNameController.text.trim(),
        "lastname": lastNameController.text.trim(),
        "emailId": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "createSchool": schoolId.isEmpty ? "true" : "false"
      };

      if (schoolId.isEmpty) {
        payload["schoolName"] = schoolNameController.text;
        payload["districtName"] = schoolDistrictController.text;
      } else {
        payload["schoolId"] = schoolId;
      }
      final response = await post(Uri.https(apiHost, '/v1/auth/signup'),
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        final jsonData =
            RegisteredUserResponse.fromJson(jsonDecode(response.body));
        context.read<User>().setUserDetails(
            userId: jsonData.data.id,
            token: jsonData.data.token,
            emailId: emailController.text,
            message: jsonData.message);
        Navigator.pushNamedAndRemoveUntil(
            context, '/app', (Route<dynamic> route) => false);
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          errorMessage = responseBody['message'];
        });
      }
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
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

  bool buttonDisability() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        schoolDistrictController.text.isNotEmpty &&
        schoolNameController.text.isNotEmpty;
  }

  List<Step> getSteps() => [
        Step(
            title: const Text(''),
            content: FirstPageWidget(
                controller: emailController,
                onNext: checkEmailAndChangeStep,
                message: message,
                statusCode: statusCode,
                otpController: otpController,
                isLoading: isLoading,
                isOtpSend: isOtpSend,
                goToLogin: goToLogin,
                termsPopup: openTermsPopup),
            isActive: currentStep >= 0),
        Step(
            title: const Text(''),
            content: SecondPageWidget(
                controller1: passwordController,
                controller2: confirmPasswordController,
                onNext: checkPasswordAndChangeStep,
                message: message,
                isPasswordValid: isPasswordValid,
                arePasswordsEqual: arePasswordsEqual,
                isPasswordHidden: isPasswordHidden,
                isConfirmPasswordHidden: isConfirmPasswordHidden,
                checkPasswordVisibility: checkPasswordVisibility,
                checkConfirmPasswordVisibility: checkConfirmPasswordVisibility,
                isAgreed: isAgreed,
                changeAgreed: changeAgreed,
                termsPopup: openTermsPopup,
                privacyPopup: openPrivacyPopup),
            isActive: currentStep >= 1),
        Step(
            title: const Text(''),
            content: ThirdPageWidget(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                schoolDistrictController: schoolDistrictController,
                schoolNameController: schoolNameController,
                onNext: registerUser,
                isLoading: isLoading,
                getDistricts: getDistrict,
                getSchools: getSchools,
                clickOnSuggestion: clickOnSuggestion,
                clickOnSchool: clickOnSchool,
                isRegisterButtonEnabled: isRegisterButtonEnabled,
                errorMessage: errorMessage),
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
    firstNameController.addListener(() {
      log(isRegisterButtonEnabled.toString());
      setState(() {
        isRegisterButtonEnabled = firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty &&
            schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });

    lastNameController.addListener(() {
      setState(() {
        isRegisterButtonEnabled = firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty &&
            schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });

    schoolNameController.addListener(() {
      setState(() {
        isRegisterButtonEnabled = firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty &&
            schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });
    schoolDistrictController.addListener(() {
      setState(() {
        isRegisterButtonEnabled = firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty &&
            schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });

    passwordController.addListener(() {
      bool hasSpecialCharacters =
          passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      setState(
        () {
          if (passwordController.text.length >= 8 &&
              passwordController.text.length < 20 &&
              hasSpecialCharacters) {
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

  void openPrivacyPopup() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "Swiirl built the Swiirl app as a Free app. This SERVICE is provided by Swiirl at no cost and is intended for use as is."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy."),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openTermsPopup() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Terms & Conditions",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Swiirl."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "Swiirl is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "You should be aware that there are certain things that Swiirl will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Swiirl cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "You should be aware that there are certain things that Swiirl will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Swiirl cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left."),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          "You should be aware that there are certain things that Swiirl will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Swiirl cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left."),
                    ),
                  ),
                ],
              ),
            ),
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
          ),
        ),
      ),
    );
  }
}
