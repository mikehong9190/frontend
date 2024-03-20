// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/helpers/ask_for_settings.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../constants.dart';
import '../model/school_details.dart';
import '../components/single_initiative.dart';
import '../store.dart';

class HomeWidget extends StatefulWidget {
  final String schoolId;
  final dynamic schoolName;
  final dynamic schoolLocation;
  const HomeWidget(
      {super.key,
      required this.schoolId,
      this.schoolName,
      this.schoolLocation});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late bool isLoading = false;
  late List<dynamic> initiatives = [];
  late String schoolName = "Aspire Public Schools";
  late String schoolLocation = "Aspire Public Schools";
  late String description = '';
  var descriptionController = TextEditingController();
  var schoolDistrictController = TextEditingController();
  var schoolNameController = TextEditingController();
  late bool isSchoolLoading = false;
  String schoolPicture = "";
  File? _image;
  XFile? _pickedFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getSchoolDetails();
    // }
    // put your logic from initState here
  }

  Future<void> _pickImage(setInnerState) async {
    final picker = ImagePicker();

    try {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        String version = androidInfo.version.release;
        if (double.parse(version) >= 13) {
          Map<Permission, PermissionStatus> statuses =
              await [Permission.photos].request();

          if (statuses[Permission.photos]!.isGranted) {
            _pickedFile = await picker.pickImage(source: ImageSource.gallery);
            if (_pickedFile != null) {
              setInnerState(() {
                _image = File(_pickedFile!.path);
              });
            } else {
              log("No image selected");
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
              setInnerState(() {
                _image = File(_pickedFile!.path);
              });
            } else {
              log("No image selected");
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
      } else {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.storage].request();
        if (statuses[Permission.storage]!.isGranted) {
          _pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (_pickedFile != null) {
            setInnerState(() {
              _image = File(_pickedFile!.path);
            });
          } else {
            log("No image selected");
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
    } catch (error, stackTrace) {
      print(stackTrace);
    }
  }

  void updateSchoolDescription(setInnerState) async {
    try {
      setInnerState(() {
        isSchoolLoading = true;
      });
      var token = context.read<User>().token;
      var userId = context.read<User>().userId;

      if (token.isEmpty && userId.isEmpty) {
        throw const FormatException('NO token or Id present');
      }
      var payload = {
        "name": schoolNameController.text,
        "district": schoolDistrictController.text,
        "description": descriptionController.text,
        "schoolId": widget.schoolId,
        "userId": userId
      };
      final response = await put(Uri.https(apiHost, '/v1/school/update'),
          body: payload, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app");
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      print(error);
    } finally {
      setInnerState(() {
        isSchoolLoading = false;
      });
    }
  }

  void uploadSchoolPicture(setInnerState) async {
    try {
      setInnerState(() {
        isSchoolLoading = true;
      });
      var token = context.read<User>().token;
      var userId = context.read<User>().userId;

      if (token.isEmpty && userId.isEmpty) {
        throw const FormatException('NO token or Id present');
      }

      var url = Uri.https(apiHost, '/v1/school/update');
      final request = MultipartRequest('PUT', url);
      final multipartFile = MultipartFile.fromBytes(
          "file", await _image!.readAsBytes(),
          filename: "jpg");
      request.files.add(multipartFile);

      request.headers['authorization'] = 'Bearer $token';
      request.fields["schoolId"] = widget.schoolId;
      request.fields["userId"] = userId;

      final response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/app");
      }
    } catch (error, stackTrace) {
      print(stackTrace);
    } finally {
      setInnerState(() {
        isSchoolLoading = false;
      });
    }
  }

  void getSchoolDetails() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final queryParameters = {"schoolId": widget.schoolId};

      final response =
          await get(Uri.https(apiHost, '/v1/school', queryParameters));
      log(response.body);

      // print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData =
            SchoolDetailResponse.fromJson(jsonDecode(utf8.decode (response.bodyBytes)));
        if (mounted) {
          setState(() {
            schoolName = jsonData.data.school.name;
            schoolLocation = jsonData.data.school.district;
            description = jsonData.data.school.description;
            descriptionController.text = jsonData.data.school.description;
            schoolDistrictController.text = jsonData.data.school.district;
            schoolNameController.text = jsonData.data.school.name;
            schoolPicture = jsonData.data.school.image ?? '';
            initiatives = jsonData.data.data;
          });
        }
      }
    } catch (error, stackTrace) {
      // print(stackTrace);
      log(stackTrace.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(context) {
    return isLoading
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ))
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: schoolPicture.isEmpty
                            ? Image.asset(
                                "assets/images/schoolDefault.jpg",
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : FancyShimmerImage(
                                imageUrl: schoolPicture,
                                boxFit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: SvgPicture.asset("assets/svg/edit.svg"),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit School Image"),
                                    content: StatefulBuilder(
                                        builder: (context, setInnerState) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _image != null
                                                ? Image.file(
                                                    _image!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(),
                                            ButtonTheme(
                                                child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _pickImage(setInnerState);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary)),
                                                child: const Text(
                                                    "Choose from Gallery",style: TextStyle(color: Colors.white)),
                                              ),
                                            )),
                                            _image != null
                                                ? ButtonTheme(
                                                    child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        uploadSchoolPicture(
                                                            setInnerState);
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary)),
                                                      child: isSchoolLoading
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : const Text("Save",style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ))
                                                : Container()
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            schoolName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Edit School Details"),
                                      content: StatefulBuilder(
                                          builder: (context, setInnerState) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: double.infinity,
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomStart,
                                                  child: Text("Name",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: TextField(
                                                  // maxLines: 10,
                                                  enabled: true,
                                                  controller:
                                                      schoolNameController,
                                                  obscureText: false,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    hintText: "Name",
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                width: double.infinity,
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomStart,
                                                  child: Text("District",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: TextField(
                                                  // maxLines: 10,
                                                  enabled: true,
                                                  controller:
                                                      schoolDistrictController,
                                                  obscureText: false,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    hintText: "District",
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                width: double.infinity,
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomStart,
                                                  child: Text(
                                                    "Description",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
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
                                                  controller:
                                                      descriptionController,
                                                  obscureText: false,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    hintText: "Description",
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              ButtonTheme(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      updateSchoolDescription(
                                                          setInnerState);
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary)),
                                                    child: isSchoolLoading
                                                        ? const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : const Text("Save",style: TextStyle(color: Colors.white)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  });
                            },
                            icon: SvgPicture.asset("assets/svg/edit.svg"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Row(children: [
                                SvgPicture.asset("assets/svg/location.svg"),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  schoolLocation,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(description),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 70, 69, 69),
                        thickness: 0.1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: initiatives.isEmpty
                        ? const Text(
                            'No initiatives added yet',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 196, 196, 196)),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: initiatives.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SingleInitiativeWidget(
                                  images: initiatives[index].images,
                                  firstName: initiatives[index].userFirstName,
                                  lastName: initiatives[index].userLastName);
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          );
  }
}
