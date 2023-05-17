// import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';

class ICamera extends StatefulWidget {
  const ICamera({super.key});

  @override
  State<ICamera> createState() => _CameraState();
}

class _CameraState extends State<ICamera> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/app");
          },
          icon: Image.asset('assets/images/camera-back.png'),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Take a Picture',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/camera-retake.png'),
              ),
            ),
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/cam-tick.png'),
              ),
            ),
          ],
        ),
      ),
      body: Column(children: [
        const Spacer(),
        SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/defaultImage.png'),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/Shutter.png'),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/Rotate.png'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
