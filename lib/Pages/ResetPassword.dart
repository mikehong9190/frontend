import 'package:google_sign_in/google_sign_in.dart';

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
import 'package:frontend/components/TextField.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  late var isVerified = false;
  late var emailId;
  late var userId;
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
      print("newPasswordController.text");
      setState(
        () {
          if (newPasswordController.text.length > 8 &&
              newPasswordController.text.length < 20) {
            setState(() {
              isNewPasswordValid = true;
            });
          } else {
            setState(() {
              isNewPasswordValid = false;
            });
          }

          if (newPasswordController.text.length > 0 &&
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userArguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      emailId = userArguments['emailId'];
      userId = userArguments['userId'];
    });
    // put your logic from initState here
  }

  void resetPassword() async {
    final payload = {
      "password": newPasswordController.text,
      "emailId": emailId,
      "userId": userId
    };
    final response = await post(
        Uri.parse(
            'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/reset-password'),
        body: jsonEncode(payload));
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, "/app", arguments: {"UserId": userId});
    }
    print(response.statusCode);
    print(response.body);
  }

  void verifyOtpForPasswordReset(email, otp) async {
    try {
      setState(() {
        isVerifyingOtp = true;
      });
      final payload = {
        "emailId": email,
        "requestType": "reset-password",
        "otp": otp
      };
      print(payload);
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/verify-otp'),
          body: jsonEncode(payload));
      print(response.body);
      if (response.statusCode == 200)
        setState(() {
          isVerified = true;
        });
    } catch (error) {
      print(error);
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
    print("EveryT");
    setState(() {
      isConfirmNewPasswordHidden = !isConfirmNewPasswordHidden;
    });
  }

  @override
  build(context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text("This is used to build your profile on swiirl",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          SizedBox(
            height: 10,
          ),
          TextFieldWidget("OTP", otpController, false, null, true),
          TextButton(
            onPressed: isVerified
                ? null
                : () {
                    verifyOtpForPasswordReset(emailId, otpController.text);
                  },
            child: isVerifyingOtp
                ? Container(
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
                            ? Color.fromRGBO(54, 189, 151, 1)
                            : Colors.blueGrey),
                  ),
          ),
          if (isVerified)
            PasswordFieldWidget(
                "New Password",
                newPasswordController,
                isNewPasswordHidden,
                isNewPasswordValid,
                true,
                checkPasswordVisibility),
          if (isVerified)
            PasswordFieldWidget(
                "Confirm New Password",
                confirmNewPasswordController,
                isConfirmNewPasswordHidden,
                arePasswordSame,
                true,
                checkConfirmPasswordVisibility),
          SizedBox(
            height: 60,
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  child: Text("Next"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: (isNewPasswordValid && arePasswordSame)
                      ? () {
                          resetPassword();
                        }
                      : null,
                )),
          ),
        ],
      ),
    ));
  }
}
