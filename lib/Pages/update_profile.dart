// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/textField.dart';
import 'package:frontend/helpers/ask_for_settings.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  bool isUploadedImage = false;
  bool firstLoad = true;
  bool isProfileUpdating = false;
  bool isLoading = false;
  bool isOtpSend = false;
  bool isOtpVerified = false;
  bool isSendingOtp = false;
  String updateErrorMessage = '';
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String version = androidInfo.version.release;
    final picker = ImagePicker();
    try {
      if (Platform.isAndroid && version == '13') {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.photos].request();
        if (statuses[Permission.photos]!.isGranted) {
          _pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (_pickedFile != null) {
            setState(() {
              _image = File(_pickedFile!.path);
              isUploadedImage = false;
            });
          }
        } else {
          bool shouldOpenSettings = await askForSettings(
              context, "Enable permissions to access your photo library");
          if (shouldOpenSettings) {
            openAppSettings();
          }

          log('no permission provided');
        }
      } else {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.storage].request();
        if (statuses[Permission.storage]!.isGranted) {
          _pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (_pickedFile != null) {
            setState(() {
              _image = File(_pickedFile!.path);
              isUploadedImage = false;
            });
          }
        } else {
          bool shouldOpenSettings = await askForSettings(
              context, "Enable permissions to access your photo library");
          if (shouldOpenSettings) {
            openAppSettings();
          }

          log('no permission provided');
        }
      }
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.watch<User>().userId;
    if (userId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      });
    }
    getUserDetails(userId);
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
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/auth/send-otp'),
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/reset-password");
      }
      // Navigator.pushNamed(context, "/reset-password",
      //     arguments: {"emailId": email, "userId": userId});
      else {}
    } catch (error) {
      log(error.toString());
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
      final token = context.read<User>().token;
      if (token.isEmpty) {
        throw const FormatException('Token is empty .. not Authorized');
      }
      setState(() {
        isProfileUpdating = true;
      });

      final response = await put(Uri.https(apiHost, '/v1/user/update'),
          body: payload,
          headers: {
            // HttpHeaders.authorizationHeader : token
            'Authorization': 'Bearer $token'
          });
      // print(response.statusCode);
      // print(response.headers);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app");
      }
    } catch (error) {
      log(error.toString());
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
      final queryParameters = {'id': id};
      final response =
          await get(Uri.https(apiHost, '/v1/user/get-all', queryParameters));
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
    } catch (error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
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
      final token = context.read<User>().token;

      var url = Uri.https(apiHost, '/v1/user/update');
      // var url = Uri.parse(
      //     'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/user/update');
      final request = MultipartRequest('PUT', url);
      request.headers['authorization'] = 'Bearer $token';
      request.fields["id"] = context.read<User>().userId;
      final multipartFile = MultipartFile.fromBytes(
          "files", await _image!.readAsBytes(),
          filename: "jpg");
      request.files.add(multipartFile);
      final response = await request.send();
      // print(response.statusCode);
      // print(response.reasonPhrase);
      if (response.statusCode == 200) {
        log("Working");
        setState(() {
          isUploadedImage = true;
        });
      }
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(context) {
    // final color = (Theme.of(context).colorScheme.secondary);
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
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: isLoading
          ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
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
                              ? CachedNetworkImage(
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  imageUrl: profilePicture,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                        value: downloadProgress.progress),
                                  ),
                                )
                              : Image.asset(
                                  "assets/images/defaultImage.png",
                                  fit: BoxFit.cover,
                                  width: 80.0,
                                  height: 80.0,
                                )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Text(
                        'Update Profile Picture',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary
                            // Theme.of(context).colorScheme.secondary
                            ),
                      ),
                      onTap: () => _pickImage(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_image != null)
                      GestureDetector(
                        onTap:
                            isUploadingImage ? null : () => uploadProfilePic(),
                        child: isUploadingImage
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : isUploadedImage
                                ? const Text("")
                                : const Text('Save'),
                      ),
                    SizedBox(
                      height: 10,
                      child: Text(updateErrorMessage),
                    ),
                    textFieldWidget(
                        "First Name", firstNameController, false, null, true),
                    const SizedBox(
                      height: 20,
                    ),
                    textFieldWidget(
                        "Last Name", lastNameController, false, null, true),
                    // textFieldWidget("Bio", bioController, false, null, true),
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
                                    Theme.of(context).colorScheme.secondary),
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
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: Align(
                            alignment: Alignment.center,
                            child: context.watch<User>().isManuallySignedIn
                                ? Row(
                                    children: [
                                      if (context
                                          .watch<User>()
                                          .isManuallySignedIn)
                                        TextButton(
                                            onPressed: () {
                                              sendOtpForPasswordReset();
                                            },
                                            child: isSendingOtp
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Text(
                                                    "Reset Password",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                  )),
                                      TextButton(
                                          onPressed: () {
                                            context
                                                .read<User>()
                                                .clearUserDetails();
                                            log(context
                                                .read<User>()
                                                .isManuallySignedIn
                                                .toString());
                                            Navigator.pushNamed(
                                                context, '/login');
                                          },
                                          child: Text('Sign Out',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary)))
                                    ],
                                  )
                                : TextButton(
                                    onPressed: () {
                                      final googleSignIn = GoogleSignIn();
                                      googleSignIn.signOut();
                                      context.read<User>().clearUserDetails();
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text('Sign Out',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary)))))
                  ]))
              // isLoading
              //   ? Align(
              //       alignment: Alignment.center,r
              //       child: CircularProgressIndicator(
              //         color: Theme.of(context).colorScheme.secondary,
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
              //               textFieldWidget("Bio", bioController, false, null, true)
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
