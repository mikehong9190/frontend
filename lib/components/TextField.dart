import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget TextFieldWidget(label, controller, isPassword) {
  // final String label;
  // TextFieldWidget ({super.key,required this.label,});
  return Column(
    children: [
      SizedBox(
        height: 30,
        width: 350,
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(label,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500))),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 50,
          width: 350,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/svg/Eye.svg"))
                  : Container(
                      width: 0,
                    ),
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              hintText: !isPassword ? label : "**********",
            ),
          )),
    ],
  );
}