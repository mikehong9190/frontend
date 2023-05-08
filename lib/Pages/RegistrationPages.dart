import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/TextField.dart';
import '../components/Button.dart';

Widget FirstPageWidget(controller,onNext) {
  return Center(
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text(
          "Enter your email address",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 30,
          width: 350,
          child: Text(
              "Sign in with our email. If you don’t have a swiirl account yet, we’ll get one set up."),
        ),
        SizedBox(
          height: 10,
        ),
        TextFieldWidget("Your Email", controller, false),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ButtonTheme(
            child: SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  child: Text("Next"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)))),
                  onPressed: () {
                    onNext ();
                  },
                )),
          ),
        ),
        OAuthButtonWidget(content: "Continue with Google", iconUrl: "URL"),
        OAuthButtonWidget(content: "Continue with Facebook", iconUrl: "URL"),
        OAuthButtonWidget(content: "Continue with Apple", iconUrl: "URL"),
        SizedBox(
          height: 50,
        ),
        SizedBox(
          width: 350,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
          ),
        )
      ]));
}

Widget SecondPageWidget(controller1, controller2,onNext) {
  return Center(
    child: Column(
      children: [
        Text(
          "Create Your Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Must be 8 character or longer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        TextFieldWidget("Password", controller1, true),
        SizedBox(
          height: 10,
        ),
        TextFieldWidget("Confirm New Password", controller2, true),
        SizedBox(
          height: 30,
        ),
        ButtonTheme(
          child: SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                child: Text("Next"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(54, 189, 151, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)))),
                onPressed: () {
                  onNext ();
                  print(controller1.text);
                  print(controller2.text);
                },
              )),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 30,
          child:
              Text("Please agree to swiirl’s Term of Use and Privacy Policy,"),
        )
      ],
    ),
  );
}


Widget ThirdPageWidget (nameController,schoolDistrictController,schoolNameController,onNext) {
    return Center(
      child: Column(
        children: [
          Text(
            "Resgistration Details",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text("This is used to build your profile on swiirl",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          SizedBox(height: 30),
          TextFieldWidget("Full Name",nameController,false),
          TextFieldWidget("School District",schoolDistrictController,false),
          TextFieldWidget("School Name",schoolNameController,false),
          SizedBox(
            height: 60,
          ),
          ButtonTheme(
            child: SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  child: Text("Next"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)))),
                  onPressed: () {onNext ();},
                )),
          ),
        ],
      ),
    );
  }