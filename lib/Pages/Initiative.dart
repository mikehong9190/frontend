import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/Pages/setup_initiative.dart';
import 'package:provider/provider.dart';
import '../store.dart';
import '../constants.dart';
import 'package:http/http.dart';
import '../components/initiatives_for_initiatives.dart';

class Welcome {
  String message;
  List<Datum> data;

  Welcome({
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  int target;
  String initiativeTypeId;
  int numberOfStudents;
  String grade;
  String name;
  List<String> images;

  Datum({
    required this.id,
    required this.target,
    required this.numberOfStudents,
    required this.initiativeTypeId,
    required this.grade,
    required this.name,
    required this.images,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        target: json["target"],
        numberOfStudents: json["numberOfStudents"],
        grade: json["grade"],
        name: json["name"],
        initiativeTypeId: json['initiativeTypeId'],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "target": target,
        "numberOfStudents": numberOfStudents,
        "grade": grade,
        "name": name,
        "initiativeId": initiativeTypeId,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}

class Initiative extends StatefulWidget {
  const Initiative({super.key});

  @override
  State<Initiative> createState() => _InitiativeState();
}

class _InitiativeState extends State<Initiative> {
  List<dynamic> initiatives = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // context.watch<User>().userId;
    // log ('By Counter ::::: ${context.watch<User>().userId}');
    // getUserDetails(widget.UserId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.read<User>().userId;
    log("From Inside $userId");
    if (userId.isNotEmpty) getInitiatives(userId);
    // }
    // put your logic from initState here
  }

  void getInitiatives(userId) async {
    try {
      setState(() {
        isLoading = true;
      });
      final queryParameters = {"id": userId};
      final response = await get(
          Uri.https(apiHost, '/v1/get-user-initiatives', queryParameters));

      if (response.statusCode == 200) {
        final jsonData = Welcome.fromJson(jsonDecode(response.body));
        setState(() {
          initiatives = jsonData.data;
        });
        log(jsonData.data.toString());
      }
      log(response.body);
    } catch (error, stackTrace) {
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
        ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(54, 189, 151, 1),
            ))
        : Center(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Spacer(),
                    const Text(
                      'Update Initiatives',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                          itemCount: initiatives.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InitiativesForInitiativeWidget(
                                  images: initiatives[index].images,
                                  target: initiatives[index].target,
                                  id: initiatives[index].id,
                                  initiativeTypeId:
                                      initiatives[index].initiativeTypeId,
                                  numberOfStudents:
                                      initiatives[index].numberOfStudents,
                                  grade: initiatives[index].grade,
                                  name: initiatives[index].name),
                            );
                          }),
                    ),
                    // Image.asset("assets/images/swiirl-black.png"),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonTheme(
                      child: SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(0, 0, 0, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SetupInitiative(),
                              ),
                            );
                          },
                          child: const Text("Start a new Initiative !"),
                        ),
                      ),
                    ),
                  ],
                )));
  }
}
