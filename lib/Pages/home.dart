// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../constants.dart';
import '../model/responses.dart';
import '../components/single_initiative.dart';

// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:frontend/Pages/camera.dart';
// import 'package:frontend/Pages/gallery.dart';
// import 'package:frontend/Pages/setup_initiative.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'package:camera/camera.dart';

// import '../model/responses.dart';
// import '../store.dart';

class HomeWidget extends StatefulWidget {
  String schoolId;
  dynamic schoolName;
  HomeWidget({super.key, required this.schoolId, this.schoolName});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late bool isLoading = false;
  late List<dynamic> initiatives = [];
  late String schoolName = "Aspire Public Schools";
  String? schoolPicture = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getSchoolDetails();
    // }
    // put your logic from initState here
  }

  void getSchoolDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      final queryParameters = {"schoolId": widget.schoolId};
      final response =
          await get(Uri.https(apiHost, '/v1/school', queryParameters));
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = SchoolData.fromJson(jsonDecode(response.body));
        setState(() {
          initiatives = [
            ...jsonData.data,
            ...jsonData.data,
            ...jsonData.data,
            ...jsonData.data
          ];
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

  @override
  Widget build(context) {
    return isLoading
        ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(54, 189, 151, 1),
            ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/images/schoolDefault.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      schoolName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const Text("About the corporate sponsor",
                        style: TextStyle(fontSize: 14))
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                      child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: initiatives.length,
                  itemBuilder: (context, index) {
                    return SingleInitiativeWidget(
                        images: initiatives[index].images,
                        firstName: initiatives[index].userFirstName,
                        lastName: initiatives[index].userLastName);
                  },
                ),
              )))
            ],
          );
    SizedBox(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: initiatives.length,
        itemBuilder: (context, index) {
          return SingleInitiativeWidget(
              images: initiatives[index].images,
              firstName: initiatives[index].userFirstName,
              lastName: initiatives[index].userLastName);
        },
      ),
    )
        // Expanded(
        // child: SingleInitiativeWidget(
        //         images: initiatives[0].images,
        //         firstName: "Aadesh",
        //         lastName: "Kamble")
        //         )
        );
  }
}
