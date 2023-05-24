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

class SingleInitiativeWidget extends StatelessWidget {
  List<String> images;
  String firstName;
  String lastName;

  SingleInitiativeWidget(
      {super.key,
      required this.images,
      required this.firstName,
      required this.lastName});

  @override
  Widget build(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$firstName $lastName",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            TextButton(onPressed: () {}, child: Text("View all"))
          ],
        ),
        Align(
          child: Text("${images.length} works",style: TextStyle(fontSize: 14)),
          alignment: Alignment.centerLeft,
        ),
        Expanded(
            child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20,top: 20),
              child: CollectiblesWidget(
                collectibleImage: images[index],
              ),
            );
          },
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
        ))
      ],
    );
  }
}
