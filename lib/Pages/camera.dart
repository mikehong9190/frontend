// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'package:frontend/pages/preview_image.dart';
import 'package:provider/provider.dart';

import '../store.dart';
import 'package:frontend/pages/gallery.dart';

class ICamera extends StatefulWidget {
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  final dynamic grade;
  final dynamic noOfStudents;
  final String? updateInitiativeId;
  final bool? isUpdate;
  const ICamera(
      {Key? key,
      required this.cameras,
      required this.isUpdate,
      required this.context,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target,
      required this.grade,
      required this.noOfStudents,
      required this.updateInitiativeId})
      : super(key: key);

  final List<CameraDescription>? cameras;
  final BuildContext context;
  @override
  State<ICamera> createState() => _CameraState();
}

class _CameraState extends State<ICamera> {
  late CameraController _cameraController;
  late CameraDescription _currentCamera;

  late dynamic id = widget.initiativeTypeId;
  late dynamic name = widget.initiativeType;
  late dynamic target = widget.target;
  late dynamic grade = widget.grade;
  late dynamic noOfStudents = widget.noOfStudents;
  late dynamic isUpdate = widget.isUpdate;
  late dynamic updateInitiativeId = widget.updateInitiativeId;

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
    var imageModel = Provider.of<User>(context);

    void goToPreview(XFile picture) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreview(
              isUpdate: isUpdate,
              picture: picture,
              initiativeTypeId: id,
              initiativeType: name,
              target: target,
              grade: grade,
              noOfStudents: noOfStudents,
              updateInitiativeId: updateInitiativeId),
        ),
      );
    }

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
        goToPreview(picture);
      } on CameraException catch (e) {
        debugPrint('OOPS: $e');
        return null;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Gallery(
                  initiativeTypeId: id,
                  initiativeType: name,
                  target: target,
                  grade: grade,
                  noOfStudents: noOfStudents,
                ),
              ),
            );
          },
          icon: SvgPicture.asset("assets/svg/Vector.svg"),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Take a Picture',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: (_cameraController.value.isInitialized)
                        ? AspectRatio(
                            aspectRatio: _cameraController.value.aspectRatio,
                            child: Stack(
                              children: [
                                CameraPreview(_cameraController),
                                GridView.count(
                                  crossAxisCount:
                                      3, // Number of columns in the grid
                                  children: List.generate(
                                    18, // Number of cells in the grid
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              171, 255, 255, 255),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
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
                                    builder: (_) => Gallery(
                                      initiativeTypeId: id,
                                      initiativeType: name,
                                      target: target,
                                      grade: grade,
                                      noOfStudents: noOfStudents,
                                    ),
                                  ),
                                );
                              },
                              icon: imageModel.images.isNotEmpty
                                  ? Image.file(
                                      File(imageModel
                                          .images[imageModel.images.length - 1]
                                          .path),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                    )
                                  : Image.asset(
                                      "assets/images/defaultImage.png",
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                    ),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
