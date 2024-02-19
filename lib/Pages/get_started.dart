import 'package:flutter/material.dart';

class GettingStartedWidget extends StatelessWidget {
  const GettingStartedWidget({super.key});

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      body: SizedBox(
        child: 
        // Stack(
          // children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: width <= 360 ? 350 : 450,
                  child: ClipRect(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            "./assets/images/swiirl-mockup.png",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                const Spacer(),
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      child: Text(
                    "Take a picture and",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  )),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: Text(
                      "rewrite the story",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                const Text(
                  "Art to Digital Collectibles in a single click",
                  style: TextStyle(fontSize: 16),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                const Spacer(),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(60),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                      icon: ClipOval(
                        child: Container(
                          width: 150,
                          height: 150,
                          color: const Color.fromRGBO(116, 231, 199, 1),
                          alignment: Alignment.center,
                          child: const Text(
                            'Start',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(child: Container()),
                const Spacer(),
                if (width > 360) SizedBox(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                        "assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
                  ),
                ),
              ],
            ),
          )
        // ]
        ),
      );
    // );
  }
}
