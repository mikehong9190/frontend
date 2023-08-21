// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/gallery.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../store.dart';
import 'dart:io';

class ImagePreview extends StatefulWidget {
  final XFile picture;
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  final dynamic grade;
  final dynamic noOfStudents;
  final String? updateInitiativeId;
  final bool? isUpdate;

  const ImagePreview(
      {Key? key,
      required this.picture,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target,
      required this.grade,
      required this.noOfStudents,
      required this.isUpdate,
      required this.updateInitiativeId})
      : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  XFile? croppedPicture;

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _cropImage(XFile imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Edit Image",
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Edit Image",
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        croppedPicture = XFile(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<User>(context);
    late dynamic id = widget.initiativeTypeId;
    late dynamic name = widget.initiativeType;
    late dynamic initiativeTarget = widget.target;
    late dynamic initiativeGrade = widget.grade;
    late dynamic initiativeNoOfStudents = widget.noOfStudents;
    late dynamic isUpdate = widget.isUpdate;
    late dynamic updateInitiativeId = widget.updateInitiativeId;

    // Use croppedPicture if available, otherwise use the original picture
    final XFile currentPicture = croppedPicture ?? widget.picture;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/svg/Vector.svg"),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Preview',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      goBack(context);
                    },
                    icon: Transform.scale(
                      scale: 1.4,
                      child: Image.asset(
                        "assets/images/retake-2.png",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      imageModel.addImage(currentPicture);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Gallery(
                            updateInitiativeId: updateInitiativeId,
                            isUpdate: isUpdate,
                            initiativeTypeId: id,
                            initiativeType: name,
                            target: initiativeTarget,
                            grade: initiativeGrade,
                            noOfStudents: initiativeNoOfStudents,
                          ),
                        ),
                      );
                    },
                    icon: Transform.scale(
                      scale: 1.4,
                      child: Image.asset("assets/images/tick-2.png"),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double desiredHeight = MediaQuery.of(context).size.height * 0.7;
                double aspectRatio = 1.0;
                Image.file(File(currentPicture.path))
                    .image
                    .resolve(const ImageConfiguration())
                    .addListener(ImageStreamListener((ImageInfo info, bool _) {
                  aspectRatio = info.image.width.toDouble() /
                      info.image.height.toDouble();
                }));

                double desiredWidth = desiredHeight * aspectRatio;

                return ClipRect(
                  child: Image.file(
                    File(currentPicture.path),
                    fit: BoxFit.contain,
                    width: desiredWidth,
                    height: desiredHeight,
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            ButtonTheme(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)))),
                  onPressed: () async {
                    await _cropImage(currentPicture);
                  },
                  child: const Text("Crop Image"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
