// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:frontend/Pages/RegistrationPages.dart';
// import 'package:frontend/Pages/login.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:im_stepper/main.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../model/responses.dart';
// import '../store.dart';
// import 'package:provider/provider.dart';

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:frontend/components/textField.dart';
import '../model/responses.dart';

import '../constants.dart';

class ForgetPasswordWidget extends StatefulWidget {
  const ForgetPasswordWidget({super.key});

  @override
  State<ForgetPasswordWidget> createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  late var isVerified = false;
  late var isLoading = false;
  // late var emailId = '';
  // late var userId = '';
  late String message = '';
  late int statusCode = 0;
  late var sendingOtp = false;
  late var isOtpSend = false;
  late var emailController = TextEditingController();
  late var isVerifyingOtp = false;
  late var isNewPasswordHidden = true;
  late var isNewPasswordValid = false;
  late var arePasswordSame = false;
  late var isConfirmNewPasswordHidden = true;
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    confirmNewPasswordController.addListener(() {
      setState(
        () {
          if (newPasswordController.text == confirmNewPasswordController.text) {
            setState(() {
              arePasswordSame = true;
            });
          } else {
            setState(() {
              arePasswordSame = false;
            });
          }
        },
      );
    });
    newPasswordController.addListener(() {
      setState(
        () {
          if (newPasswordController.text.length >= 8 &&
              newPasswordController.text.length < 20) {
            setState(() {
              isNewPasswordValid = true;
            });
          } else {
            setState(() {
              isNewPasswordValid = false;
            });
          }

          if (newPasswordController.text.isNotEmpty &&
              newPasswordController.text == confirmNewPasswordController.text) {
            setState(() {
              arePasswordSame = true;
            });
          } else {
            setState(() {
              arePasswordSame = false;
            });
          }
        },
      );
    });
  }

  void sendOTP() async {
    final payload = {
      "emailId": emailController.text.trim(),
      "requestType": "password"
    };

    try {
      setState(() {
        sendingOtp = true;
      });
      final response = await post(Uri.https(apiHost, '/v1/auth/validate-email'),
          body: jsonEncode(payload));
      log(response.body);
      final jsonData =
          EmailVerificationResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        setState(() {
          statusCode = response.statusCode;
          isOtpSend = true;
          message = "OTP send Successfully";
        });
      } else {
        setState(() {
          statusCode = response.statusCode;
          message = jsonData.message;
        });
      }
    } catch (error, stackTrace) {
      log(stackTrace.toString());
    } finally {
      setState(() {
        sendingOtp = false;
      });
    }
  }

  void resetPassword() async {
    final payload = {
      "password": newPasswordController.text.trim(),
      "emailId": emailController.text.trim()
    };
    setState(() {
      isLoading = true;
    });
    try {
      final response = await post(Uri.https(apiHost, '/v1/user/reset-password'),
          body: jsonEncode(payload));
      log(response.body);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/login");
        // Navigator.pushNamed(context, "/app", arguments: {"UserId": userId,"message" : "Password Reset"});
      } else {
        setState(() {
          statusCode = response.statusCode;
          message = "Error while resetting password";
        });
      }
      // log(response.statusCode);
      log(response.body);
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyOtpForPasswordReset(otp) async {
    try {
      setState(() {
        isVerifyingOtp = true;
      });
      final payload = {
        "emailId": emailController.text.trim(),
        "requestType": "password",
        "otp": otp
      };

      final response = await post(Uri.https(apiHost, '/v1/auth/verify-otp'),
          body: jsonEncode(payload));
      final jsonData =
          OTPVerificationResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        setState(() {
          statusCode = response.statusCode;
          message = jsonData.message;
          isVerified = true;
        });
      } else {
        setState(() {
          statusCode = response.statusCode;
          message = jsonData.message;
        });
      }
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isVerifyingOtp = false;
      });
    }
  }

  void checkPasswordVisibility() async {
    setState(() {
      isNewPasswordHidden = !isNewPasswordHidden;
    });
  }

  void checkConfirmPasswordVisibility() async {
    setState(() {
      isConfirmNewPasswordHidden = !isConfirmNewPasswordHidden;
    });
  }

  @override
  build(context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // const Align(
            //   alignment: Alignment.center,
            //   child: Text("This is used to build your profile on swiirl",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            // ),
            const SizedBox(
              height: 10,
            ),
            textFieldWidget(
                "Your Email", emailController, false, null, !isOtpSend),
            TextButton(
              onPressed: isOtpSend
                  ? null
                  : () {
                      sendOTP();
                    },
              child: sendingOtp
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      "Send OTP",
                      style: TextStyle(
                          color: !isVerified
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.blueGrey),
                    ),
            ),
            if (isOtpSend)
              textFieldWidget("OTP", otpController, false, null, true),
            if (isOtpSend)
              TextButton(
                onPressed: isVerified
                    ? null
                    : () {
                        verifyOtpForPasswordReset(otpController.text);
                      },
                child: isVerifyingOtp
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "Verify OTP",
                        style: TextStyle(
                            color: !isVerified
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.blueGrey),
                      ),
              ),
            if (statusCode != 0)
              SizedBox(
                  height: 20,
                  child: Text(
                    message,
                    style: TextStyle(
                        color: statusCode == 200 ? Colors.green : Colors.red),
                  )),
            if (isVerified)
              passwordFieldWidget(
                  "New Password",
                  newPasswordController,
                  isNewPasswordHidden,
                  isNewPasswordValid,
                  true,
                  checkPasswordVisibility),
            if (isVerified)
              passwordFieldWidget(
                  "Confirm New Password",
                  confirmNewPasswordController,
                  isConfirmNewPasswordHidden,
                  arePasswordSame,
                  true,
                  checkConfirmPasswordVisibility),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0)))),
                    onPressed: (isNewPasswordValid && arePasswordSame)
                        ? () {
                            resetPassword();
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
      )),
    );
  }
}
