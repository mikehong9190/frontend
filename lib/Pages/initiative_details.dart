// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/gallery.dart';
// import 'package:frontend/Pages/initiative.dart';
import 'package:provider/provider.dart';

import '../store.dart';
import '../constants.dart';
import '../model/initiative_details.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class InitiativesDetailsWidget extends StatefulWidget {
  final String id;
  const InitiativesDetailsWidget({Key? key, required this.id})
      : super(key: key);

  @override
  _InitiativesDetailsWidgetState createState() =>
      _InitiativesDetailsWidgetState();
}

class _InitiativesDetailsWidgetState extends State<InitiativesDetailsWidget> {
  bool isLoading = false;
  // bool isDeleting = false;
  bool error = false;
  String errorMessage = '';
  int target = 0;
  int numberOfStudent = 0;
  String initiativeTypeId = '';
  String grade = '';
  String name = '';
  List<String> removeImageKeys = [];
  List<dynamic> imageKeys = [];

  Future<bool> _onWillPop() async {
    Navigator.pushNamed(context, '/app');
    return false;
  }

  @override
  void initState() {
    super.initState();
    getInitiativesDetails(widget.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void deleteErrorPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Image(s)"),
            content: const Text("Error while deleting Image"),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void deleteImage(setInnerState) async {
    try {
      var token = context.read<User>().token;
      if (token.isEmpty) {
        throw const FormatException('Token not found.');
      }
      var payload = {
        "imageKeys": [
          ...removeImageKeys.map((image) => image.split(".com/")[1])
        ]
      };
      var url = Uri.https(apiHost, '/v1/initiative/deleteImage');

      delete(
        url,
        body: json.encode(payload),
        headers: {'Authorization': 'Bearer $token'},
      ).then((response) {
        Navigator.pop(context);
        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InitiativesDetailsWidget(id: widget.id),
            ),
          );
        } else {
          deleteErrorPopup();
        }
      });
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {
      setState(() {
        removeImageKeys = [];
      });
    }
  }

  void getInitiativesDetails(id) async {
    try {
      setState(() {
        isLoading = true;
      });
      var queryParameters = {"id": widget.id};
      var url = Uri.https(
          apiHost, '/v1/initiative/getInitiativeById', queryParameters);
      final response = await get(url);
      if (response.statusCode == 200) {
        final jsonData = InitiativeDetails.fromJson(jsonDecode(response.body));
        target = jsonData.data.target;
        numberOfStudent = jsonData.data.numberOfStudents;
        grade = jsonData.data.grade;
        imageKeys = jsonData.data.images;
        name = jsonData.data.name;
        initiativeTypeId = jsonData.data.initiativeTypeId;

        setState(() {
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Error while fetching Data';
        });
      }
    } catch (error, stackTrace) {
      print(stackTrace);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleImage(imageUrl) {
    setState(() {
      if (removeImageKeys.contains(imageUrl)) {
        removeImageKeys.remove(imageUrl);
      } else {
        removeImageKeys.add(imageUrl);
      }
    });
  }

  void deletePopup() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isDeleting = false;
        return StatefulBuilder(builder: (context, setInnerState) {
          return AlertDialog(
            title: const Text("Delete Image(s)"),
            content: isDeleting
                ? SizedBox(
                    width: 50,
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : const Text("Do you want to delete the selected images?"),
            actions: [
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () {
                        Navigator.pop(context);
                        setState(() {
                          removeImageKeys = [];
                        });
                      },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () {
                        setInnerState(() {
                          isDeleting = true;
                        });
                        deleteImage(setInnerState);
                      },
                child: const Text("Yes"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          actions: removeImageKeys.isEmpty
              ? null
              : [
                  IconButton(
                    onPressed: () {
                      deletePopup();
                    },
                    icon: SvgPicture.asset("assets/svg/bin.svg"),
                  )
                ],
          leading: removeImageKeys.isEmpty
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/app');
                  },
                  icon: SvgPicture.asset("assets/svg/Vector.svg"),
                )
              : Container(),
          backgroundColor: removeImageKeys.isEmpty
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
          title: removeImageKeys.isEmpty
              ? const Text(
                  'Initiative Details',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                )
              : Text(removeImageKeys.length.toString()),
        ),
        body: isLoading
            ? Column(
                children: [
                  const SizedBox(height: 70),
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$grade - $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Students : $numberOfStudent',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 115, 146, 116),
                                  fontSize: 17),
                            ),
                            const Spacer(),
                            Text(
                              'Target : $target',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 115, 146, 116),
                                  fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Artworks',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ButtonTheme(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Gallery(
                                          isUpdate: true,
                                          updateInitiativeId: widget.id,
                                          initiativeTypeId: initiativeTypeId,
                                          initiativeType: name,
                                          target: target,
                                          grade: grade,
                                          noOfStudents: numberOfStudent),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.only(top: 15, bottom: 15)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)))),
                                child: const Text("Add more art")),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        // width: double.infinity,
                        child: imageKeys.isNotEmpty
                            ? GridView.count(
                                // padding: const EdgeInsets.only(top: 10),
                                primary: false,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                crossAxisCount: 2,
                                children: [
                                  ...imageKeys.map(
                                    (image) => GestureDetector(
                                      onTap: () {
                                        toggleImage(image);
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: FancyShimmerImage(
                                                  imageUrl: image,
                                                  boxFit: BoxFit.cover,
                                                  width: double.infinity,
                                                  // height:
                                                  //     MediaQuery.of(context).size.height *
                                                  //         0.15,
                                                ),
                                              ),
                                              if (removeImageKeys
                                                  .contains(image))
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
                                          if (removeImageKeys.contains(image))
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
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
                                  "No artwork here",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
