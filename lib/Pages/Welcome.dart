import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
                child: Opacity(
                    opacity: 1,
                    child: Image.asset("assets/images/cover.png",
                        fit: BoxFit.cover))),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Image.asset("assets/images/swiirl.png"),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: IconButton(
                          onPressed: () {
                            log("Working");
                            Navigator.pushNamed(context, "/getStarted");
                          },
                          icon: SizedBox(
                            height: 100,
                            width: 100,
                            child: SvgPicture.asset("assets/svg/Next.svg"),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Artfully Funding the Future',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
