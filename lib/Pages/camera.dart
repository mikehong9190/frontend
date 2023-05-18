// import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'package:frontend/Pages/gallery.dart';

class ICamera extends StatefulWidget {
  const ICamera({Key? key, required this.cameras, required this.context})
      : super(key: key);

  final List<CameraDescription>? cameras;
  final BuildContext context;
  @override
  State<ICamera> createState() => _CameraState();
}

class _CameraState extends State<ICamera> {
  late CameraController _cameraController;
  late CameraDescription _currentCamera;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentCamera = widget.cameras![0];
    initCamera(_currentCamera);
  }

  // void goToPreview(XFile picture) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ImagePreview(picture),
  //     ),
  //   );
  // }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      // goToPreview(picture);
    } on CameraException catch (e) {
      debugPrint('OOPS: $e');
      return null;
    }
  }

  Future toggleCamera() async {
    final CameraDescription newCamera = (_currentCamera == widget.cameras![0])
        ? widget.cameras![1]
        : widget.cameras![0];

    await _cameraController.dispose();
    initCamera(newCamera);
    setState(() {
      _currentCamera = newCamera;
    });
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("Camera Error $e");
    }
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
            icon: SvgPicture.asset("assets/svg/Vector.svg")),
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
        // const Spacer(),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: (_cameraController.value.isInitialized)
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: _cameraController.value.previewSize!.height,
                      height: _cameraController.value.previewSize!.width,
                      child: CameraPreview(_cameraController),
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ),
        ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Gallery(),
                      ),
                    );
                  },
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
                  onPressed: takePicture,
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
                  onPressed: toggleCamera,
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
