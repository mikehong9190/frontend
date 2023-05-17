import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/TextField.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../model/responses.dart';
import '../store.dart';
import '../constants.dart';

class UpdateProfileWidget extends StatefulWidget {
  const UpdateProfileWidget({super.key});

  @override
  State<UpdateProfileWidget> createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  File? _image;
  XFile? _pickedFile;
  bool isUploadingImage = false;
  bool firstLoad = true;
  bool isProfileUpdating = false;
  bool isLoading = false;
  bool isOtpSend = false;
  bool isOtpVerified = false;
  bool isSendingOtp = false;
  String profilePicture = '';
  // late String userId;
  // late String message;
  // late String emailId;
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
    _pickedFile = (await _picker.pickImage(source: ImageSource.gallery));
    if (_pickedFile != null) {
      setState(() {
        print(_pickedFile);
        print(_pickedFile!.path);
        _image = File(_pickedFile!.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.watch<User>().userId;
    print(userId);
    if (userId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      });
    }
    // if (userId.isEmpty) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushNamed(context, '/');
    //   });
    //   return;
    // } else {
    getUserDetails(userId);
    // }
    // final UserId = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // setState(() {
    //   userId = UserId["UserId"];
    //   message = UserId["message"];
    // });
    // put your logic from initState here
  }

  void sendOtpForPasswordReset() async {
    try {
      setState(
        () {
          isSendingOtp = true;
        },
      );
      final payload = {
        "emailId": context.read<User>().emailId,
        "requestType": "reset-password"
      };
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/send-otp'),
          body: jsonEncode(payload));
      if (response.statusCode == 200)
        Navigator.pushNamed(context, "/reset-password");
      // Navigator.pushNamed(context, "/reset-password",
      //     arguments: {"emailId": email, "userId": userId});
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

  void updateUserDetails() async {
    final payload = {
      "id": context.read<User>().userId,
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
      // print(response.body);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app");
        // Navigator.pushNamed(context, "/app",
        //     arguments: {"UserId": id, "message": "User updated Successfully"});
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
      final queryParameters = {'id' : id};
      final response = await get(Uri.https(apiHost, '/v1/users',queryParameters));
      if (response.statusCode == 200) {
        final jsonData =
            (UserDetailsResponse.fromJson(jsonDecode(response.body)).data);
        setState(() {
          profilePicture = jsonData.profilePicture;
          // emailId = jsonData.email;
          firstNameController.text = jsonData.firstName;
          lastNameController.text = jsonData.lastName;
          bioController.text = jsonData.bio ?? '';
        });
      }
    } catch (error,stackTrace) {
      print (stackTrace);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void uploadProfilePic() async {
    try {
      setState(() {
        isUploadingImage = true;
      });
      var url = Uri.https(apiHost, '/v1/users/update-profile');
      // var url = Uri.parse(
      //     'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/update-profile');
      final request = MultipartRequest('PUT', url);
      request.fields["id"] = context.read<User>().userId;
      final multipartFile = MultipartFile.fromBytes(
          "files", await _image!.readAsBytes(),
          filename: "jpg");
      request.files.add(multipartFile);
      final response = await request.send();
      if (response.statusCode == 200) {
        // setState(() {
        //   _image = null;
        // });
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isUploadingImage = false;
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
                Navigator.pushNamed(context, "/app");
                // Navigator.pushNamed(context, "/app",
                //     arguments: {"UserId": userId, "message": message});
              },
              icon: SvgPicture.asset("assets/svg/Vector.svg")),
          backgroundColor: Colors.white,
          title: const Text('Update Profile',
              style: TextStyle(
                color: Colors.black87,
              ))),
      body: isLoading
          ? const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Color.fromRGBO(54, 189, 151, 1),
              ))
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ClipOval(
                        child: (_image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              )
                            : profilePicture.isNotEmpty
                                ? Image.network(
                                    profilePicture,
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                  )
                                : Image.asset(
                                    "assets/images/defaultImage.png",
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                  ))),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: const Text('Update Profile Picture',
                          style: TextStyle(
                              color: Color.fromRGBO(54, 189, 151, 1))),
                      onTap: () => _pickImage(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_image != null)
                      GestureDetector(
                        child: isUploadingImage
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : const Text('Save'),
                        onTap:
                            isUploadingImage ? null : () => uploadProfilePic(),
                      ),
                    TextFieldWidget(
                        "First Name", firstNameController, false, null, true),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                        "Last Name", lastNameController, false, null, true),
                    // TextFieldWidget("Bio", bioController, false, null, true),
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                          width: double.infinity,
                          child: Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child: Text("Your Bio",
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: TextField(
                              maxLines: 10,
                              enabled: true,
                              controller: bioController,
                              obscureText: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: "Bio",
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ButtonTheme(
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(54, 189, 151, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                            onPressed: () {
                              updateUserDetails();
                            },
                            child: isProfileUpdating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Update Profile'),
                          )),
                    ),

                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Center(
                          child: Row(
                            children: [
                              if (context.watch<User>().isManuallySignedIn)
                                TextButton(
                                    onPressed: () {
                                      sendOtpForPasswordReset();
                                    },
                                    child: isSendingOtp
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          )
                                        : const Text(
                                            "Reset Password",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    54, 189, 151, 1)),
                                          )),
                              TextButton(
                                  onPressed: () {
                                    context.read<User>().clearUserDetails();
                                    Navigator.pushNamed(context, '/');
                                  },
                                  child: Text('Sign Out',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(54, 189, 151, 1))))
                            ],
                          ),
                        ))
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
              ),
    );
  }
}
