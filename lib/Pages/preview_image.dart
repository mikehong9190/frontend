import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/gallery.dart';
import 'package:provider/provider.dart';

import '../store.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final XFile picture;
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  final dynamic grade;
  final dynamic noOfStudents;

  const ImagePreview(
      {Key? key,
      required this.picture,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target,
      required this.grade,
      required this.noOfStudents})
      : super(key: key);

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<User>(context);
    late dynamic id = initiativeTypeId;
    late dynamic name = initiativeType;
    late dynamic initiativeTarget = target;
    late dynamic initiativeGrade = grade;
    late dynamic initiativeNoOfStudents = noOfStudents;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("assets/svg/Vector.svg")),
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
          // mainAxisAlignment: MainAxisAlignment.center,
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
                      imageModel.addImage(picture);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Gallery(
                              initiativeTypeId: id,
                              initiativeType: name,
                              target: initiativeTarget,
                              grade: initiativeGrade,
                              noOfStudents: initiativeNoOfStudents),
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
            Image.file(
              File(picture.path),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(height: 25),
            Text(
              picture.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
