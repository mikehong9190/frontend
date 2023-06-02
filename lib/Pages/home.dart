// import 'dart:convert';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../model/school_details.dart';
import '../components/single_initiative.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../store.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:frontend/Pages/camera.dart';
// import 'package:frontend/Pages/gallery.dart';
// import 'package:frontend/Pages/setup_initiative.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'package:camera/camera.dart';

// import '../model/responses.dart';
// import '../store.dart';

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
    try {
      final picker = ImagePicker();
      _pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (_pickedFile != null) {
        setInnerState(() {
          _image = File(_pickedFile!.path);
        });
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
        "description": descriptionController.text,
        "schoolId": widget.schoolId,
        "userId": userId
      };
      final response = await put(Uri.https(apiHost, '/v1/school/update'),
          body: payload,
          headers: {
            // HttpHeaders.authorizationHeader : token
            'Authorization': 'Bearer $token'
          });
      print(response.statusCode);
      print(response.body);
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
      setState(() {
        isLoading = true;
      });
      final queryParameters = {"schoolId": widget.schoolId};
      print("---------- ${widget.schoolId} -------------");
      final response =
          await get(Uri.https(apiHost, '/v1/school', queryParameters));
      log(response.body);
      print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData =
            SchoolDetailResponse.fromJson(jsonDecode(response.body));
        print(jsonData.data.toString());
        setState(() {
          schoolName = jsonData.data.school.name;
          schoolLocation = jsonData.data.school.district;
          description = jsonData.data.school.description;
          descriptionController.text = jsonData.data.school.description;
          schoolPicture = jsonData.data.school.image ?? '';
          initiatives = jsonData.data.data;
        });
      }
    } catch (error, stackTrace) {
      print(stackTrace);
      log(stackTrace.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
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
            //     child: ConstrainedBox(
            //     constraints: BoxConstraints(
            //       maxHeight: MediaQuery.of(context).size.height + 1000,
            //     ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    Container(
                      // height: MediaQuery.of(context).size.height / 4,
                      // width: MediaQuery.of(context).size.width,
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
                                                        "Choose from Gallery")),
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
                                                              backgroundColor: MaterialStateProperty
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
                                                              : const Text(
                                                                  "Save")),
                                                    ))
                                                  : Container()
                                            ],
                                          ));
                                    }));
                              });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        schoolName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ),
                    Row(children: [
                      SvgPicture.asset("assets/svg/location.svg"),
                      Text(
                        schoolLocation,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(description),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: const Text(
                                            "Edit School Description"),
                                        content: StatefulBuilder(
                                            builder: (context, setInnerState) {
                                          return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
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
                                                                  BorderRadius
                                                                      .zero,
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                          hintText:
                                                              "Description",
                                                        ),
                                                      )),
                                                  ButtonTheme(
                                                      child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          updateSchoolDescription(
                                                              setInnerState);
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty
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
                                                            : const Text(
                                                                "Save")),
                                                  ))
                                                ],
                                              ));
                                        }));
                                  });
                            },
                            // onPressed: () {
                            //   showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         title: const Text("Edit School Details"),
                            //         content: StatefulBuilder(
                            //           builder: (context, setInnerState) {
                            //             return SizedBox(
                            //               child: Column(
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 40,
                            //                     width: double.infinity,
                            //                     child: TextField(
                            //                       maxLines: 10,
                            //                       enabled: true,
                            //                       controller:
                            //                           descriptionController,
                            //                       obscureText: false,
                            //                       decoration:
                            //                           const InputDecoration(
                            //                         border: OutlineInputBorder(
                            //                           borderRadius:
                            //                               BorderRadius.zero,
                            //                           borderSide: BorderSide(
                            //                             color: Colors.black,
                            //                           ),
                            //                         ),
                            //                         hintText: "Description",
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   ButtonTheme(
                            //                     child: SizedBox(
                            //                       width: double.infinity,
                            //                       child: ElevatedButton(
                            //                         onPressed: () {
                            //                           updateSchoolDescription();
                            //                         },
                            //                         style: ButtonStyle(
                            //                           backgroundColor:
                            //                               MaterialStateProperty
                            //                                   .all(
                            //                             Theme.of(context)
                            //                                 .colorScheme
                            //                                 .secondary,
                            //                           ),
                            //                         ),
                            //                         child: const Text("Save"),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     },
                            //   );
                            // },
                            icon: SvgPicture.asset("assets/svg/edit.svg"),
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
              // Expanded(
              //     child:
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
              ))
            ],
          ));
  }
}
