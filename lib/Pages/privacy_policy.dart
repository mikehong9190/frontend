import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyWidget extends StatelessWidget {
  const PrivacyWidget({super.key});

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/registration", arguments: true);
            },
            icon: SvgPicture.asset("assets/svg/Vector.svg"),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Privacy Policy",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                      "Swiirl built the Swiirl app as a Free app. This SERVICE is provided by Swiirl at no cost and is intended for use as is."),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                      "This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service."),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                      "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy."),
                ),
              ),
            ],
          ),
        ));
  }
}
