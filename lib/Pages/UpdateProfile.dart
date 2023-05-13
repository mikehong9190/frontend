import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/TextField.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../model/responses.dart';

class UpdateProfileWidget extends StatefulWidget {
  UpdateProfileWidget({super.key});

  @override
  State<UpdateProfileWidget> createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  File? _image;
  PickedFile? _pickedFile;
  bool firstLoad = true;
  bool isProfileUpdating = false;
  bool isLoading = false;
  bool isOtpSend = false;
  bool isOtpVerified = false;
  bool isSendingOtp = false;
  late String userId;
  late String message;
  late String emailId;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final _picker = ImagePicker();
    _pickedFile =
        (await _picker.pickImage(source: ImageSource.gallery)) as PickedFile?;
    if (_pickedFile != null) {
      setState(() {
        print(_pickedFile!.path);
        _image = File(_pickedFile!.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final UserId = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      userId = UserId["UserId"];
      message = UserId["message"];
    });
    getUserDetails(UserId["UserId"]);
    // put your logic from initState here
  }

  void sendOtpForPasswordReset(email) async {
    try {
      setState(
        () {
          isSendingOtp = true;
        },
      );
      final payload = {"emailId": email, "requestType": "reset-password"};
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/send-otp'),
          body: jsonEncode(payload));
      if (response.statusCode == 200)
        Navigator.pushNamed(context, "/reset-password",
            arguments: {"emailId": email, "userId": userId});
    } catch (error) {
      print(error);
    } finally {
      setState(
        () {
          isSendingOtp = false;
        },
      );
    }
  }

  void updateUserDetails(id) async {
    final payload = {
      "id": id,
      "bio": bioController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text
    };
    try {
      setState(() {
        isProfileUpdating = true;
      });
      final response = await put(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/update-profile'),
          body: payload);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app", arguments: {"UserId": id});
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isProfileUpdating = false;
      });
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
        print (response.body);
        setState(() async {
          emailId = jsonData.email;
          firstNameController.text = jsonData.firstName;
          lastNameController.text = jsonData.lastName;
          bioController.text = jsonData.bio == null ? '' : jsonData.bio;
        });
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/app",
                      arguments: {"UserId": userId, "message": message});
                },
                icon: SvgPicture.asset("assets/svg/Vector.svg")),
            backgroundColor: Colors.white,
            title: Text('Update Profile',
                style: TextStyle(
                  color: Colors.black87,
                ))),
        body: isLoading
            ? const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(54, 189, 151, 1),
                ))
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SizedBox(
                      height: 20,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 50,
                    ),
                    // GestureDetector(
                    //   child: Text('Update Profile Pic'),
                    //   onTap: () => _pickImage(),
                    // ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: TextFieldWidget("First Name",
                            firstNameController, false, null, true)),
                    Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextFieldWidget("Last Name", lastNameController,
                            false, null, true)),
                    // TextFieldWidget("Bio", bioController, false, null, true),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 350,
                          child: Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child: Text("Your Bio",
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 80,
                            width: 350,
                            child: TextField(
                              maxLines: 10,
                              enabled: true,
                              controller: bioController,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: "Bio",
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (message == "Account created successfully!")
                      TextButton(
                          onPressed: () {
                            sendOtpForPasswordReset(emailId);
                          },
                          child: isSendingOtp
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Color.fromRGBO(54, 189, 151, 1)),
                                )),
                    SizedBox(
                      height: 40,
                    ),
                    ButtonTheme(
                      child: SizedBox(
                          height: 50,
                          width: 350,
                          child: ElevatedButton(
                            child: isProfileUpdating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    child:
                                        // CircularProgressIndicator(
                                        //   color: Colors.white,
                                        // ),
                                        Text('Update Profile'),
                                  ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(54, 189, 151, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
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
