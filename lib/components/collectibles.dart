import 'package:flutter/material.dart';
// import 'package:frontend/Pages/home.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/app.dart';
import 'package:frontend/Pages/forgetPassword.dart';
import 'package:frontend/Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectiblesWidget extends StatelessWidget {
  dynamic collectibleImage;
  CollectiblesWidget({super.key, this.collectibleImage});

  @override
  Widget build(context) {
    return SizedBox(
        width: 200,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: collectibleImage.isNotEmpty
                  ? Image.network(
                      collectibleImage,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/defaultImage.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: Text(
            //     "Collectibles Names",
            //     style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [Text("Price"), Text("50")],
            // )
          ],
        ));
  }
}