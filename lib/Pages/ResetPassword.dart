import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:frontend/Pages/RegistrationPages.dart';
// import 'package:frontend/Pages/login.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:im_stepper/main.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import '../model/responses.dart';
import 'package:http/http.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/TextField.dart';
import 'package:provider/provider.dart';

import '../store.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  late var isVerified = false;
  late var isLoading = false;
  // late var emailId = '';
  // late var userId = '';
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
      // print("newPasswordController.text");
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.watch<User>().userId;
    // if (userId.isEmpty) {
    //   Navigator.pushNamed(context, '/');
    //   return;
    // }
    // final userArguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // setState(() {
    //   emailId = userArguments['emailId'];
    //   userId = userArguments['userId'];
    // });
    // put your logic from initState here
  }

  void resetPassword() async {
    final payload = {
      "password": newPasswordController.text,
      "emailId": context.read<User>().emailId,
      "userId": context.read<User>().userId
    };
// <<<<<<< login-integration
    setState(() {
      isLoading = true;
    });
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/reset-password'),
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app");
        // Navigator.pushNamed(context, "/app", arguments: {"UserId": userId,"message" : "Password Reseted"});
      }
      // print(response.statusCode);
      print(response.body);
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
// =======
//     final response = await post(
//         Uri.parse(
//             'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/reset-password'),
//         body: jsonEncode(payload));
//     if (response.statusCode == 200) {
//       Navigator.pushNamed(context, "/app", arguments: {
//         "UserId": userId,
//         "message": "Password updated successfully"
// >>>>>>> dev
      });
    }
  }

  void verifyOtpForPasswordReset(otp) async {
    try {
      setState(() {
        isVerifyingOtp = true;
      });
      final payload = {
        "emailId": context.read<User>().emailId,
        "requestType": "reset-password",
        "otp": otp
      };
      print(payload);
      // print(payload);
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/verify-otp'),
          body: jsonEncode(payload));
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isVerified = true;
        });
      }
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
    setState(() {
      isConfirmNewPasswordHidden = !isConfirmNewPasswordHidden;
    });
  }

  @override
  build(context) {
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
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text("This is used to build your profile on swiirl",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget("OTP", otpController, false, null, true),
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
                            ? const Color.fromRGBO(54, 189, 151, 1)
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
                          const Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
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
    ));
  }
}
