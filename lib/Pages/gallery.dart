// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers/ask_for_settings.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:frontend/Pages/camera.dart';
import '../store.dart';

class Gallery extends StatefulWidget {
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  final dynamic grade;
  final dynamic noOfStudents;
  final String? updateInitiativeId;
  final bool? isUpdate;

  const Gallery(
      {super.key,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target,
      required this.grade,
      required this.noOfStudents,
      this.updateInitiativeId,
      this.isUpdate = false});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late dynamic id = widget.initiativeTypeId;
  late dynamic updateInitiativeId = widget.updateInitiativeId;
  late dynamic name = widget.initiativeType;
  late dynamic target = widget.target;
  late dynamic grade = widget.grade;
  late dynamic noOfStudents = widget.noOfStudents;
  late dynamic isUpdate = widget.isUpdate;
  dynamic initiativeId = '';
  List<dynamic> imageKeys = [];

  bool isLoading = false;

  String getContentType(XFile file) {
    final contentTypeMap = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
    };

    final fileExtension = file.path.split('.').last.toLowerCase();
    return contentTypeMap[fileExtension] ?? 'application/octet-stream';
  }

  String getImageExtension(XFile file) {
    final fileExtension = file.path.split('.').last.toLowerCase();
    return fileExtension;
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Images uploaded successfully"),
        actions: [
          CupertinoDialogAction(
              child: const Text("Okay"),
              onPressed: () => {Navigator.pushNamed(context, "/app")}),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Failure"),
        content: const Text("Unable to upload, Please try again"),
        actions: [
          CupertinoDialogAction(
              child: const Text("Okay"),
              onPressed: () => {Navigator.of(context).pop()}),
        ],
      ),
    );
  }

  //upload images to s3 bucket using pre-signed urls
  void uploadImages(context, List<dynamic> urls, List<XFile> images) async {
    try {
      for (var i = 0; i < urls.length; i++) {
        String contentType = getContentType(images[i]);
        Uri uri = Uri.parse(urls[i]);
        var response = await put(
          uri,
          body: await images[i].readAsBytes(),
          headers: {"Content-Type": contentType},
        );
        if (response.statusCode != 200) {
          log(response.reasonPhrase.toString());
          throw Exception('Failed to upload image at index $i');
        }
      }
      log("Step 2 --------- done");
      log("Images uploaded successfully");
      createInitiative(context);
    } catch (error) {
      log('Error while uploading images: $error');
    }
  }

  //Get pre signed urls for all images from backend
  void getPresignedUrls(context, List<XFile> images) async {
    setState(() {
      isLoading = true;
    });
    var imageModel = Provider.of<User>(context, listen: false);
    var userId = imageModel.userId;
    List<dynamic> imageContentTypes = [];

    for (final image in images) {
      String contentType = getContentType(image);
      imageContentTypes.add(contentType);
    }
    final payload = {
      "contentTypes": imageContentTypes,
      "userId": userId,
      "initiative": name
    };
    try {
      final response = await post(
          Uri.parse(
              'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/initiative/get-presigned-urls'),
          body: jsonEncode(payload));

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        initiativeId = updateInitiativeId ?? res['id'];
        imageKeys = res['keys'];
        log("Step 1---------done");
        uploadImages(context, res['urls'], images);
      } else {
        log(response.toString());
      }
    } catch (error) {
      log(error.toString());
    }
  }

  //create initiative once all images are uploaded using presigned urls
  void createInitiative(context) async {
    try {
      var user = Provider.of<User>(context, listen: false);
      var imageModel = Provider.of<User>(context, listen: false);
      var token = user.token;

      final payload = {
        "userId": user.userId,
        "initiativeTypeId": id,
        "initiativeId": initiativeId,
        "name": name,
        "target": '$target',
        "grade": grade,
        "numberOfStudents": '$noOfStudents',
        "imageKeys": imageKeys
      };
      final updatePayload = {
        "userId": user.userId,
        "initiativeId": initiativeId,
        "imageKeys": imageKeys
      };
      String url = isUpdate
          ? 'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/initiative/update'
          : 'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/initiative/create';
      final response;
      if (isUpdate) {
        response = await put(Uri.parse(url),
            body: jsonEncode(updatePayload),
            headers: {'Authorization': 'Bearer $token'});
      } else {
        response = await post(Uri.parse(url),
            body: jsonEncode(payload),
            headers: {'Authorization': 'Bearer $token'});
      }

      if (response.statusCode == 200) {
        log("Step 3---------done");
        _showSuccessDialog(context);
        imageModel.clearImages();
        imageModel.clearFinalImages();
        log('Initiative uploaded successfully');
        setState(() {
          isLoading = false;
        });
      } else {
        _showAlertDialog(context);
        if (isUpdate) {
          log('Error updating initiative: ${response.reasonPhrase}');
        } else {
          log('Error creating initiative: ${response.reasonPhrase}');
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(context) {
    var imageModel = Provider.of<User>(context);
    final ImagePicker imgpicker = ImagePicker();

    Future<bool> onWillPop() async {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Discard Initiative"),
            content: const Text("Do you want to discard this initiative?"),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  imageModel.clearImages();
                  imageModel.clearFinalImages();
                  Navigator.pushNamed(context, '/app');
                  // Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ).then((value) => value ?? false);
    }

    openImages() async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String version = androidInfo.version.release;
      try {
        if (Platform.isAndroid && version == '13') {
          // print("hello");
          Map<Permission, PermissionStatus> statuses =
              await [Permission.photos].request();
          if (statuses[Permission.photos]!.isGranted) {
            var pickedfiles = await imgpicker.pickMultiImage();
            // ignore: unnecessary_null_comparison
            if (pickedfiles != null) {
              for (var i = 0; i < pickedfiles.length; i++) {
                imageModel.addImage(pickedfiles[i]);
              }
            } else {
              log("no image selected");
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
            var pickedfiles = await imgpicker.pickMultiImage();
            // ignore: unnecessary_null_comparison
            if (pickedfiles != null) {
              for (var i = 0; i < pickedfiles.length; i++) {
                imageModel.addImage(pickedfiles[i]);
              }
            } else {
              log("no image selected");
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
      } catch (e) {
        log("error while picking file. $e");
      }
    }

    openCamera() async {
      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.camera,
        ].request();
        if (statuses[Permission.camera]!.isGranted) {
          List<CameraDescription> cameras = await availableCameras();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ICamera(
                updateInitiativeId: updateInitiativeId,
                isUpdate: isUpdate,
                initiativeTypeId: id,
                initiativeType: name,
                target: target,
                grade: grade,
                noOfStudents: noOfStudents,
                cameras: cameras,
                context: context,
              ),
            ),
          );
        } else {
          bool shouldOpenSettings = await askForSettings(
              context, 'Swiirl does not have access to your camera.');
          if (shouldOpenSettings) {
            openAppSettings();
          }
          log('no permission provided');
        }
      } catch (e) {
        log("error while picking file. $e");
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              onWillPop().then((shouldDiscard) {
                if (shouldDiscard) {
                  Navigator.of(context).pop();
                }
              });
            },
            icon: SvgPicture.asset("assets/svg/Vector.svg")),
        backgroundColor: Colors.white,
        title: const Text(
          'Upload to Cloud',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "$grade",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              isLoading
                  ? Column(children: [
                      const SizedBox(height: 70),
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ])
                  : Container(
                      margin: const EdgeInsets.only(top: 50),
                      width: double.infinity,
                      child: imageModel.images.isNotEmpty
                          ? GridView.count(
                              padding: const EdgeInsets.only(top: 10),
                              primary: false,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              crossAxisCount: 2,
                              children: <Widget>[
                                ...imageModel.images.map(
                                  (image) => GestureDetector(
                                    onTap: () {
                                      imageModel.toggleImage(image);
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 35,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.file(
                                                  File(image.path),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                ),
                                              ),
                                              if (imageModel
                                                  .isImageExists(image))
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (imageModel.isImageExists(image))
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Image.asset(
                                              "assets/images/select.png",
                                              // width: 30,
                                              // height: 150,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                                isUpdate
                                    ? "Add more artworks"
                                    : "No artworks added yet",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                    ),
              Positioned(
                bottom: 16.0,
                left: 0,
                child: SizedBox(
                  // width: 80,
                  height: 55,
                  width: 370,
                  child: FittedBox(
                    child: FloatingActionButton.extended(
                      label: Text(
                        "Click to Upload",
                        style: TextStyle(
                          color: imageModel.finalImages.isNotEmpty
                              ? Colors.white
                              : const Color.fromARGB(255, 212, 211, 211),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      onPressed: imageModel.finalImages.isNotEmpty
                          ? () {
                              getPresignedUrls(context, imageModel.finalImages);
                            }
                          : null,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 0,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text("Choose From Gallery"),
                                  onTap: openImages,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text("Take a Photo"),
                                  onTap: openCamera,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
