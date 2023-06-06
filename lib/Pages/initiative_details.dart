import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../store.dart';
import '../constants.dart';
import '../model/initiative_details.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class InitiativesDetailsWidget extends StatefulWidget {
  final String id;
  const InitiativesDetailsWidget({super.key, required this.id});

  @override
  State<InitiativesDetailsWidget> createState() => _InitiativesDetailsWidget();
}

class _InitiativesDetailsWidget extends State<InitiativesDetailsWidget> {
  bool isLoading = false;
  String errorMessage = '';
  int target = 0;
  int numberOfStudent = 0;
  String grade = '';
  String name = '';
  List<String> removeImageKeys = [];
  List<dynamic> imageKeys = [];

  @override
  void initState() {
    super.initState();
    getInitiativesDetails(widget.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void deleteImage() async {
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
      delete(url,
          body: json.encode(payload),
          headers: {'Authorization': 'Bearer $token'}).then((response) {
        // print(response.body);
        if (response.statusCode == 200) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InitiativesDetailsWidget(id: widget.id),
            ),
          );
          setState(() {
            removeImageKeys = [];
          });
        }
      });
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    } finally {}
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
    var newRemoveImageKeys = [...removeImageKeys];
    if (removeImageKeys.contains(imageUrl)) {
      newRemoveImageKeys.remove(imageUrl);
    } else {
      newRemoveImageKeys.add(imageUrl);
    }
    setState(() {
      removeImageKeys = newRemoveImageKeys;
    });
  }

  void deletePopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setInnerState) {
          return AlertDialog(
            title: const Text("Delete Image(s)"),
            content: const Text("Do you want to delete the selected images"),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    removeImageKeys = [];
                  });
                  // Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  deleteImage();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
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
                      icon: SvgPicture.asset("assets/svg/bin.svg"))
                ],
          leading: removeImageKeys.isEmpty
              ? IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/svg/Vector.svg"))
              : Container(),
          backgroundColor: removeImageKeys.isEmpty
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
          title: removeImageKeys.isEmpty
              ? Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                )
              : Text(removeImageKeys.length.toString()),
        ),
        body: isLoading
            ? Column(children: [
                const SizedBox(height: 70),
                Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ])
            : Container(
                margin: const EdgeInsets.only(top: 50),
                width: double.infinity,
                child: imageKeys.isNotEmpty
                    ? GridView.count(
                        padding: const EdgeInsets.only(top: 10),
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
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 35,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
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
                                            child: FancyShimmerImage(
                                              imageUrl: image,
                                              boxFit: BoxFit.cover,
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                            )),
                                        if (removeImageKeys.contains(image))
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (removeImageKeys.contains(image))
                                    Positioned(
                                      top: 0,
                                      right: 0,
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
                          "No artwork here",
                          style: TextStyle(fontSize: 16),
                        ),
                      )));
  }
}
