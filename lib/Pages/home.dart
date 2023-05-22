// import 'dart:convert';

import 'package:flutter/material.dart';
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
  HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late String schoolName = "Aspire Public Schools";
  String? schoolPicture = "";

  @override
  Widget build(context) {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      heightFactor: 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Image.asset(
            'assets/images/schoolDefault.jpg',
          ),
          const Text("Aspire Public Schools"),
        ]),
      ),
    );
  }
}
