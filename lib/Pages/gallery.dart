// import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/Pages/camera.dart';

import '../store.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});
  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
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
                  Container(
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
                              ...imageModel.images.map((image) => Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 30,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Shadow color
                                              spreadRadius: 1, // Spread radius
                                              blurRadius: 3, // Blur radius
                                              offset: const Offset(0,
                                                  2), // Offset in x and y direction
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () =>
                                              imageModel.removeImage(image),
                                          iconSize: 25,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )),
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
                          label: const Text("Click to Upload"),
                          backgroundColor:
                              const Color.fromRGBO(54, 189, 151, 1),
                          onPressed: () {},
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
                                          child:
                                              const Text("Choose From Gallery"),
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
                                          color:
                                              Color.fromRGBO(54, 189, 151, 1))),
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
            )));
  }
}
