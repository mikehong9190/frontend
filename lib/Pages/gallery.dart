// import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/Pages/camera.dart';
import 'package:http/http.dart' as http;

import '../store.dart';

class Gallery extends StatefulWidget {
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  final dynamic grade;
  final dynamic noOfStudents;
  const Gallery(
      {super.key,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target,
      required this.grade,
      required this.noOfStudents});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late dynamic id = widget.initiativeTypeId;
  late dynamic name = widget.initiativeType;
  late dynamic target = widget.target;
  late dynamic grade = widget.grade;
  late dynamic noOfStudents = widget.noOfStudents;
  bool isLoading = false;

  void _showAlertDialog(BuildContext context) {
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

  void uploadImages(context, List<XFile> images) async {
    if (images.isEmpty) return;
    try {
      setState(() {
        isLoading = true;
      });
      var user = Provider.of<User>(context, listen: false);
      var imageModel = Provider.of<User>(context, listen: false);

      final url = Uri.parse(
          "https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/create-initiative");
      final request = http.MultipartRequest('POST', url);
      for (final image in images) {
        final multipartFile = http.MultipartFile.fromBytes(
            'files', await image.readAsBytes(),
            filename: image.name);
        request.files.add(multipartFile);
      }
      request.fields['userId'] = user.userId;
      request.fields['initiativeTypeId'] = id;
      request.fields['name'] = name;
      request.fields['target'] = '$target';
      request.fields['grade'] = grade;
      request.fields['numberOfStudents'] = '$noOfStudents';

      final response = await request.send();

      if (response.statusCode == 200) {
        _showAlertDialog(context);
        imageModel.clearImages();
        print('Initiative uploaded successfully');
        setState(() {
          isLoading = false;
        });
      } else {
        // print(response.body);
        print('Error uploading file: ${response.reasonPhrase}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: ${e}");
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
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ).then((value) => value ?? false);
    }

    openImages() async {
      try {
        var pickedfiles = await imgpicker.pickMultiImage();
        // ignore: unnecessary_null_comparison
        if (pickedfiles != null) {
          for (var i = 0; i < pickedfiles.length; i++) {
            imageModel.addImage(pickedfiles[i]);
          }
        } else {
          print("no image selected");
        }
      } catch (e) {
        print("error while picking file. $e");
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
                child: Row(
                  children: const [
                    Text("New Collection",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800))
                  ],
                ),
              ),
              isLoading
                  ? Column(children: const [
                      SizedBox(height: 70),
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(54, 189, 151, 1),
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
                                            // child: Icon(
                                            //   Icons.check_circle,
                                            //   color: Colors.green,
                                            //   size: 30,
                                            // ),
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
                          : const Center(
                              child: Text(
                                "No artworks added yet",
                                style: TextStyle(fontSize: 16),
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
                      backgroundColor: const Color.fromRGBO(54, 189, 151, 1),
                      onPressed: imageModel.finalImages.isNotEmpty
                          ? () {
                              uploadImages(context, imageModel.finalImages);
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
                  backgroundColor: const Color.fromRGBO(54, 189, 151, 1),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Add Artworks"),
                          content: SizedBox(
                            height: 98,
                            child: Column(
                              children: [
                                ButtonTheme(
                                  child: SizedBox(
                                    // height: 10,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    54, 189, 151, 1)),
                                      ),
                                      onPressed: openImages,
                                      child: const Text("Choose From Gallery"),
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  child: SizedBox(
                                    // height: 10,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    54, 189, 151, 1)),
                                      ),
                                      onPressed: () async {
                                        await availableCameras().then(
                                          (value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ICamera(
                                                  initiativeTypeId: id,
                                                  initiativeType: name,
                                                  target: target,
                                                  grade: grade,
                                                  noOfStudents: noOfStudents,
                                                  cameras: value,
                                                  context: context),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Take a photo"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close',
                                  style: TextStyle(
                                      color: Color.fromRGBO(54, 189, 151, 1))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
