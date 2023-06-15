// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:convert';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:textfield_search/textfield_search.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../model/responses.dart';
import '../store.dart';
import '../constants.dart';


  Future<void> _launchInBrowser(String url) async {
     await FlutterWebBrowser.openWebPage(
  url: url);
  }

class FirstPageWidget extends StatelessWidget {
  final dynamic controller;
  final dynamic onNext;
  final dynamic message;
  final dynamic statusCode;
  final dynamic otpController;
  final dynamic isLoading;
  final dynamic isOtpSend;
  final dynamic goToLogin;
  final dynamic termsPopup;

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }

  const FirstPageWidget(
      {super.key,
      required this.controller,
      required this.onNext,
      required this.message,
      required this.statusCode,
      required this.otpController,
      required this.isLoading,
      required this.isOtpSend,
      required this.goToLogin,
      required this.termsPopup});

  @override
  build(context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Enter your email address",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              "Sign in with our email. If you don’t have a swiirl account yet, we’ll get one set up.",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(132, 143, 172, 1)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          textFieldWidget("Your Email", controller, false, null, !isOtpSend),
          const SizedBox(
            height: 10,
          ),
          if (isOtpSend)
            textFieldWidget("OTP", otpController, false, null, true),
          const SizedBox(
            height: 10,
          ),
          if (statusCode != 0)
            SizedBox(
                height: 20,
                child: Text(
                  message,
                  style: TextStyle(
                      color: statusCode == 200 ? Colors.green : Colors.red),
                )),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: ButtonTheme(
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(50.0)))),
                    onPressed: isValidEmail(controller.text)
                        ? () {
                            onNext();
                          }
                        : null,
                    child: !isLoading
                        ? const Text("Next")
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  )),
            ),
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
              const Text("Already have an account ?"),
              TextButton(
                  onPressed: goToLogin,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ))
            ],
          ),
          // OAuthButtonWidget("Continue with Facebook", "Facebook"),
          // OAuthButtonWidget("Continue with Apple", "Apple"),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset("assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
            ),
          )
        ]));
  }
}

class SecondPageWidget extends StatelessWidget {
  final dynamic controller1;
  final dynamic controller2;
  final dynamic onNext;
  final String message;
  final bool isPasswordValid;
  final bool arePasswordsEqual;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final dynamic checkPasswordVisibility;
  final dynamic checkConfirmPasswordVisibility;
  final bool isAgreed;
  final dynamic changeAgreed;
  final dynamic termsPopup;
  final dynamic privacyPopup;
  const SecondPageWidget(
      {super.key,
      required this.controller1,
      required this.controller2,
      required this.onNext,
      required this.message,
      required this.isPasswordValid,
      required this.arePasswordsEqual,
      required this.isPasswordHidden,
      required this.isConfirmPasswordHidden,
      required this.checkPasswordVisibility,
      required this.checkConfirmPasswordVisibility,
      required this.isAgreed,
      required this.changeAgreed,
      required this.termsPopup,
      required this.privacyPopup});

  @override
  Widget build(context) {
    return Center(
      child: Column(
        children: [
          const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Create Your Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
                "The password must be at least 8 characters long and include at least one letter, number, and symbol, and it should not contain more than 20 characters.",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(132, 143, 172, 1))),
          ),
          const SizedBox(
            height: 30,
          ),
          passwordFieldWidget("Password", controller1, isPasswordHidden,
              isPasswordValid, true, checkPasswordVisibility),
          const SizedBox(
            height: 10,
          ),
          passwordFieldWidget(
              "Confirm New Password",
              controller2,
              isConfirmPasswordHidden,
              arePasswordsEqual,
              true,
              checkConfirmPasswordVisibility),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 20,
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              )),
          const SizedBox(
            height: 20,
          ),
          // const SizedBox(
          //   height: 30,
          //   child: Text("Please agree to swiirl’s"),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const InkWell(
                onTap: null,
                child: Text("Please agree to swiirl’s  "),
              ),
              InkWell(
                child: const Text("Terms of use ",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  var url = Uri.parse(termsPage);
                  _launchInBrowser(termsPage);
                },
              ),
              const InkWell(
                onTap: null,
                child: Text("and  "),
              ),
              InkWell(
                child: const Text("Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                   var url = Uri.parse(privacyPage);
                  _launchInBrowser(privacyPage);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isAgreed,
                  onChanged: changeAgreed,
                  fillColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  shape: const CircleBorder(),
                ),
                const Text("I Agree")
              ],
            ),
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: isPasswordValid && arePasswordsEqual && isAgreed
                      ? () {
                          onNext();
                          // log(controller1.text);
                          // log(controller2.text);
                        }
                      : null,
                  child: const Text("Next"),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            width: 350,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset("assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
            ),
          )
        ],
      ),
    );
  }
}

class ThirdPageWidget extends StatelessWidget {
  final dynamic firstNameController;
  final dynamic lastNameController;
  final dynamic schoolDistrictController;
  final dynamic schoolNameController;
  final dynamic onNext;
  final dynamic isLoading;
  final dynamic getDistricts;
  final dynamic getSchools;
  final dynamic clickOnSuggestion;
  final dynamic clickOnSchool;
  final dynamic isRegisterButtonEnabled;

  const ThirdPageWidget({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.schoolDistrictController,
    required this.schoolNameController,
    required this.onNext,
    required this.isLoading,
    required this.getDistricts,
    required this.getSchools,
    required this.clickOnSuggestion,
    required this.clickOnSchool,
    required this.isRegisterButtonEnabled,
  });

  @override
  build(context) {
    return Center(
      child: Column(
        children: [
          const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Registration Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text("This is used to build your profile on swiirl",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(132, 143, 172, 1),
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          textFieldWidget("First Name", firstNameController, false, null, true),
          const SizedBox(
            height: 15,
          ),
          textFieldWidget("Last Name", lastNameController, false, null, true),
          searchTextFieldWidget("School District", schoolDistrictController,
              false, null, getDistricts, clickOnSuggestion),
          schoolSearchFieldWidget("School Name", schoolNameController, false,
              null, getSchools, clickOnSchool),
          // textFieldWidget(
          //     "School District", schoolDistrictController, false, null, true),
          // textFieldWidget("School Name", schoolNameController, false, null, true),
          const SizedBox(
            height: 60,
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: isRegisterButtonEnabled
                      ? () {
                          onNext();
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
        ],
      ),
    );
  }
}

class GoogleAuthWidget extends StatefulWidget {
  const GoogleAuthWidget({super.key});

  @override
  State<GoogleAuthWidget> createState() => _GoogleAuthWidgetState();
}

class _GoogleAuthWidgetState extends State<GoogleAuthWidget> {
  final schoolNameController = TextEditingController();
  final schoolDistrictController = TextEditingController();
  late var schoolId = '';
  late var isRegisterButtonEnabled = false;
  bool isLoading = false;
  // late var userId;

  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // final UserId = (ModalRoute.of(context)?.settings.arguments ??
  //   //     <String, dynamic>{}) as Map;
  //   // setState(() {
  //   //   userId = UserId["id"];
  //   // });
  //   // put your logic from initState here
  // }

  @override
  void initState() {
    super.initState();
    schoolNameController.addListener(() {
      setState(() {
        isRegisterButtonEnabled = schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });
    schoolDistrictController.addListener(() {
      setState(() {
        isRegisterButtonEnabled = schoolDistrictController.text.isNotEmpty &&
            schoolNameController.text.isNotEmpty;
      });
    });
  }

  Future<List<SingleDistrictResponse>> getDistricts(String query) async {
    try {
      final response = await get(
        Uri.parse(
            'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/school/search?text=$query'),
      );
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

  Future<List<School>> getSchools(String query) async {
    try {
      final response = await get(Uri.parse(
          'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/school/search?text=&district=${schoolDistrictController.text}'));
      if (response.statusCode == 200) {
        final jsonData = SchoolList.fromJson(jsonDecode(response.body));
        return jsonData.data;
      } else {
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  void clickOnSuggestion(value, controller) {
    setState(() {
      controller.text = value;
    });
  }

  void clickOnSchool(id, name, controller) {
    log(id);
    setState(() {
      controller.text = name;
      schoolId = id;
    });
  }

  void createUser() async {
    try {
      // log("Hello");
      setState(() {
        isLoading = true;
      });
      if (context.read<User>().userId.isEmpty) throw Error();
      late var payload = {
        "id": context.read<User>().userId,
        "createSchool": schoolId.isEmpty ? "true" : "false"
      };
      if (schoolId.isEmpty) {
        payload["schoolName"] = schoolNameController.text;
        payload["districtName"] = schoolDistrictController.text;
      } else {
        payload["schoolId"] = schoolId;
      }
      // log(payload);
      final response = await put(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/auth/update-school-details'),
          body: jsonEncode(payload));
      // log(response.body);
      if (response.statusCode == 200) Navigator.pushNamed(context, '/app');
      // Navigator.pushNamed(context, '/app',
      //     arguments: {"UserId": userId, "message": "Google Sign in"});
      // log(jsonDecode(response.body));
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        schoolId = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
              alignment: Alignment.center,
              child: Text(
                "School Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text("This is used to build your profile on swiirl",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(132, 143, 172, 1))),
          ),
          const SizedBox(
            height: 10,
          ),
          searchTextFieldWidget("School District", schoolDistrictController,
              false, null, getDistricts, clickOnSuggestion),
          schoolSearchFieldWidget("School Name", schoolNameController, false,
              null, getSchools, clickOnSchool),
          // textFieldWidget(
          //     "School District", schoolDistrictController, false, null, true),
          // textFieldWidget("School Name", schoolNameController, false, null, true),
          const SizedBox(
            height: 60,
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: isRegisterButtonEnabled
                      ? () {
                          createUser();
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
        ],
      ),
    ));
  }
}
