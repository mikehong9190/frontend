import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:textfield_search/textfield_search.dart';

import '../components/TextField.dart';
import '../components/Button.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../model/responses.dart';

Widget FirstPageWidget(controller, onNext, message, statusCode, otpController,
    isLoading, isOtpSend) {
  return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
    TextFieldWidget("Your Email", controller, false, null, !isOtpSend),
    const SizedBox(
      height: 10,
    ),
    if (isOtpSend) TextFieldWidget("OTP", otpController, false, null, true),
    const SizedBox(
      height: 10,
    ),
    if (statusCode == 200 || statusCode == 400)
      SizedBox(
          height: 20,
          child: Text(
            message,
            style:
                TextStyle(color: statusCode == 200 ? Colors.green : Colors.red),
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
                      const Color.fromRGBO(54, 189, 151, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)))),
              onPressed: controller.text.contains("@")
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
    const OAuthButtonWidget(content: "Continue with Google", iconUrl: "Google"),
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

Widget SecondPageWidget(
    controller1,
    controller2,
    onNext,
    message,
    isPasswordValid,
    arePasswordsEqual,
    isPasswordHidden,
    isConfirmPasswordHidden,
    checkPasswordVisiblity,
    checkConfirmPasswordVisiblity) {
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
        PasswordFieldWidget("Password", controller1, isPasswordHidden,
            isPasswordValid, true, checkPasswordVisiblity),
        const SizedBox(
          height: 10,
        ),
        PasswordFieldWidget(
            "Confirm New Password",
            controller2,
            isConfirmPasswordHidden,
            arePasswordsEqual,
            true,
            checkConfirmPasswordVisiblity),
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
        const SizedBox(
          height: 30,
          child:
              Text("Please agree to swiirl’s Term of Use and Privacy Policy,"),
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
                onPressed: () {
                  onNext();
                  // print(controller1.text);
                  // print(controller2.text);
                },
                child: const Text("Next"),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 180,
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

Widget ThirdPageWidget(
    firstNameController,
    lastNameController,
    schoolDistrictController,
    schoolNameController,
    onNext,
    isLoading,
    getDistricts,
    getSchools,
    clickOnSuggestion,
    clickOnSchool) {
  print(getSchools);
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
        TextFieldWidget("First Name", firstNameController, false, null, true),
        const SizedBox(
          height: 15,
        ),
        TextFieldWidget("Last Name", lastNameController, false, null, true),
        SearchTextFieldWidget("School District", schoolDistrictController,
            false, null, getDistricts, clickOnSuggestion),
        SchoolSearchFieldWidget("School Name", schoolNameController, false,
            null, getSchools, clickOnSchool),
        // TextFieldWidget(
        //     "School District", schoolDistrictController, false, null, true),
        // TextFieldWidget("School Name", schoolNameController, false, null, true),
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
                onPressed: () {
                  onNext();
                },
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

class GoogleAuthWidget extends StatefulWidget {
  const GoogleAuthWidget({super.key});

  @override
  State<GoogleAuthWidget> createState() => _GoogleAuthWidgetState();
}

class _GoogleAuthWidgetState extends State<GoogleAuthWidget> {
  final schoolNameController = TextEditingController();
  final schoolDistrictController = TextEditingController();
  late var schoolId = '';
  bool isLoading = false;
  late var userId;
  void didChangeDependencies() {
    super.didChangeDependencies();
    final UserId = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      userId = UserId["id"];
    });
    // put your logic from initState here
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
      print(error);
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
      print(error);
      return [];
    }
  }

  void clickOnSuggestion(value, controller) {
    setState(() {
      controller.text = value;
    });
  }

  void clickOnSchool(id, name, controller) {
    print(id);
    setState(() {
      controller.text = name;
      schoolId = id;
    });
  }

  void createUser() async {
    try {
      // print("Hello");
      setState(() {
        isLoading = true;
      });
      late var payload = {
        "id": userId,
        "createSchool": schoolId.isEmpty ? "true" : "false"
      };
      if (schoolId.isEmpty) {
        payload["schoolName"] = schoolNameController.text;
        payload["districtName"] = schoolDistrictController.text;
      } else {
        payload["schoolId"] = schoolId;
      }
      // print(payload);
      final response = await put(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/update-school-details'),
          body: jsonEncode(payload));
      // print(response.body);
      if (response.statusCode == 200) print("dksjfdf");
      Navigator.pushNamed(context, '/app',
          arguments: {"UserId": userId, "message": "Google Sign in"});
      // print(jsonDecode(response.body));
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        schoolId = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: implement build
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
          SearchTextFieldWidget("School District", schoolDistrictController,
              false, null, getDistricts, clickOnSuggestion),
          SchoolSearchFieldWidget("School Name", schoolNameController, false,
              null, getSchools, clickOnSchool),
          // TextFieldWidget(
          //     "School District", schoolDistrictController, false, null, true),
          // TextFieldWidget("School Name", schoolNameController, false, null, true),
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
                  onPressed: () {
                    createUser();
                  },
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


// class ResetPasswordWidget extends StatefulWidget {
//   const ResetPasswordWidget({super.key});

//   @override
//   _ResetPasswordWidgetState createState() => _ResetPasswordWidgetState();
// }

// class _ResetPasswordWidgetState extends State<GoogleAuthWidget> {
  
//   final otpController = TextEditingController();
//   late var schoolId = '';
//   bool isLoading = false;

  

  

//   void clickOnSuggestion(value, controller) {
//     setState(() {
//       controller.text = value;
//     });
//   }

//   void clickOnSchool(id, name, controller) {
//     print(id);
//     setState(() {
//       controller.text = name;
//       schoolId = id;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build

//     return Center(
//       child: Column(
//         children: [
//           Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 "Registration Details",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text("This is used to build your profile on swiirl",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           SearchTextFieldWidget("School District", schoolDistrictController,
//               false, null, getDistricts, clickOnSuggestion),
//           SchoolSearchFieldWidget("School Name", schoolNameController, false,
//               null, getSchools, clickOnSchool),
//           // TextFieldWidget(
//           //     "School District", schoolDistrictController, false, null, true),
//           // TextFieldWidget("School Name", schoolNameController, false, null, true),
//           SizedBox(
//             height: 60,
//           ),
//           ButtonTheme(
//             child: SizedBox(
//                 height: 50,
//                 width: 350,
//                 child: ElevatedButton(
//                   child: isLoading
//                       ? Container(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         )
//                       : Text("Next"),
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           Color.fromRGBO(54, 189, 151, 1)),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0)))),
//                   onPressed: () {},
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }