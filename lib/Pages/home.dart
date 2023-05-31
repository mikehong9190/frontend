// import 'dart:convert';

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../constants.dart';
import '../model/responses.dart';
import '../components/single_initiative.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final String schoolId;
  final dynamic schoolName;
  final dynamic schoolLocation;
  const HomeWidget(
      {super.key,
      required this.schoolId,
      this.schoolName,
      this.schoolLocation});

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
      log(response.body);
      if (response.statusCode == 200) {
        final jsonData = SchoolData.fromJson(jsonDecode(response.body));
        setState(() {
          initiatives = jsonData.data;
        });
      }
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
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ))
        : SingleChildScrollView(
            //     child: ConstrainedBox(
            //     constraints: BoxConstraints(
            //       maxHeight: MediaQuery.of(context).size.height + 1000,
            //     ),
            child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.schoolName ?? "NAME",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ),
                    Row(children: [
                      SvgPicture.asset("assets/svg/location.svg"),
                      Text(
                        widget.schoolLocation ?? 'LOCATION',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      )
                    ])
                  ],
                ),
              ),
              // Expanded(
              //     child:
              SizedBox(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: initiatives.isEmpty
                    ? const Text("No Artworks added yet",
                        style: TextStyle(fontSize: 18))
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: initiatives.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SingleInitiativeWidget(
                              images: initiatives[index].images,
                              firstName: initiatives[index].userFirstName,
                              lastName: initiatives[index].userLastName);
                        },
                      ),
              ))
            ],
          ));
  }
}
