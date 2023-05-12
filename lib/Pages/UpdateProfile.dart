import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/TextField.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';

import '../model/responses.dart';

class UpdateProfileWidget extends StatefulWidget {
  UpdateProfileWidget({super.key});

  @override
  State<UpdateProfileWidget> createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  bool firstLoad = true;
  bool isLoading = false;
  bool isOtpSend = false;
  bool isOtpVerified = false;
  // ignore: non_constant_identifier_names
  late String userId;
  late String emailId;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final UserId = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      userId = UserId["UserId"];
    });
    getUserDetails(UserId["UserId"]);
    // put your logic from initState here
  }

  void sendOtpForPasswordReset(email) async {
    try {
      final payload = {"emailId": email, "requestType": "reset-password"};

      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/send-otp'),
          body: jsonEncode(payload));
      if (response.statusCode == 200)
        setState(() {
          isOtpSend = true;
        });
    } catch (error) {
      print(error);
    }
  }

  void verifyOtpForPasswordReset(email, otp) async {
    try {
      final payload = {
        "emailId": email,
        "requestType": "reset-password",
        "otp": otp
      };
        final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/verify-otp'),
          body: jsonEncode(payload));
        print (response.body);
        if (response.statusCode == 200) setState(() {
          isOtpVerified = true;
        }); 
    } catch (error) {
      print(error);
    }
  }

  void updateUserDetails(id) async {
    final payload = {
      "id": id,
      "bio": bioController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text
    };
    final response = await put(
        Uri.parse(
            'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/update-profile'),
        body: payload);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, "/app", arguments: {"UserId": id});
    }
  }

  void getUserDetails(id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await get(Uri.parse(
          'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/users?id=$id'));
      if (response.statusCode == 200) {
        final jsonData =
            (UserDetailsResponse.fromJson(jsonDecode(response.body)).data);
        print("---------------------");
        setState(() {
          emailId = jsonData.email;
          firstNameController.text = jsonData.firstName;
          lastNameController.text = jsonData.lastName;
          bioController.text = jsonData.bio == null ? '' : jsonData.bio;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(context) {
    // getUserDetails(UserId["UserId"]);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/app",
                      arguments: {"UserId": userId});
                },
                icon: SvgPicture.asset("assets/svg/Vector.svg")),
            backgroundColor: Colors.white,
            title: Text('Update Profile',
                style: TextStyle(
                  color: Colors.black87,
                ))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 30,
              ),
              TextFieldWidget(
                  "First Name", firstNameController, false, null, true),
              TextFieldWidget(
                  "Last Name", lastNameController, false, null, true),
              TextFieldWidget("Bio", bioController, false, null, true),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    sendOtpForPasswordReset(emailId);
                  },
                  child: Text("Reset Password")),
              if (isOtpSend)
                TextFieldWidget("OTP", otpController, false, null, true),
              if (isOtpSend) TextButton(onPressed: () {verifyOtpForPasswordReset (emailId,otpController.text);}, child: Text ("Verify OTP")),
              if (isOtpVerified) 
              SizedBox(
                height: 40,
              ),
              ButtonTheme(
                child: SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      child: Container(
                        width: 20,
                        height: 20,
                        child:
                            // CircularProgressIndicator(
                            //   color: Colors.white,
                            // ),
                            Text('Update Profile'),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(54, 189, 151, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                      onPressed: () {
                        updateUserDetails(userId);
                      },
                    )),
              )
            ]))
        // isLoading
        //   ? Align(
        //       alignment: Alignment.center,r
        //       child: CircularProgressIndicator(
        //         color: Color.fromRGBO(54, 189, 151, 1),
        //       ))
        //   : FractionallySizedBox(
        //       alignment: Alignment.topCenter,
        //       heightFactor: .4,
        //       child: Container(
        //         padding: EdgeInsets.only(left: 40, right: 40),
        //         child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               CircleAvatar(
        //                     backgroundColor: Colors.amber,
        //                     radius: 30,
        //                   ),
        //               TextFieldWidget("Bio", bioController, false, null, true)
        //             ]),
        //       )),
        // bottomNavigationBar: BottomNavigationBar(
        //     iconSize: 20.0,
        //     type: BottomNavigationBarType.fixed,
        //     items: _bottomNavigationBar,
        //     currentIndex: _currentIndex,
        //     selectedItemColor: Color.fromRGBO(116, 231, 199, 1),
        //     onTap: changeIndex)
        );
  }
}
