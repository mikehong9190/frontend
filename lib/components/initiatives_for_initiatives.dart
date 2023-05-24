import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/Initiative.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/responses.dart';
import '../store.dart';
import '../constants.dart';
import 'collectibles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InitiativesForInitiativeWidget extends StatelessWidget {
  int target;
  int numberOfStudents;
  String grade;
  String name;
  List<String> images;

  InitiativesForInitiativeWidget(
      {super.key,
      required this.images,
      required this.target,
      required this.numberOfStudents,
      required this.grade,
      required this.name});

  @override
  Widget build(context) {
    return Row(
      children: [
        CachedNetworkImage(
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            imageUrl: images[0],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(54, 189, 151, 1)),
                      value: downloadProgress.progress),
                )),
        Padding(
          padding: EdgeInsets.only(left: 30),
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Padding(
                  child: Text("by ${grade} Grade"),
                  padding: EdgeInsets.only(top : 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Amount Raised"), Text(target.toString())],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
