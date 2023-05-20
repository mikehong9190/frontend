import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/app.dart';
import 'package:frontend/Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/RadioButton.dart';

Widget SetupInitiativeWidget(initialValue,onChanged) {
  return Center(
    child: Column(children: [
      const Text(
        "Set up your initiative",
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(
        height: 20,
      ),
      const SizedBox(
        height: 30,
        width: 350,
        child: Text("What are you fundraising for"),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 500,
        child: Column(children: [
          MyRadioButton(
              title: InitiativeTypeEnum.computer.name,
              value: InitiativeTypeEnum.computer,
              initiativeTypeEnum: initialValue,
              onChanged : onChanged
              ),
          MyRadioButton(
              title: InitiativeTypeEnum.science.name,
              value: InitiativeTypeEnum.science,
              initiativeTypeEnum: initialValue,
              onChanged : onChanged
              ),
        ]),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          child: SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(54, 189, 151, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)))),
                onPressed: () {
                },
                child: const Text("Next"),
              )),
        ),
      )
    ]),
  );
}