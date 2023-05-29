import 'package:cached_network_image/cached_network_image.dart';
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
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: collectibleImage.isNotEmpty
              ? CachedNetworkImage(
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  imageUrl: collectibleImage,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(54, 189, 151, 1)),
                            value: downloadProgress.progress),
                      ))
              // Image.network(
              //     collectibleImage,
              //     width: 150,
              //     height: 150,
              //     fit: BoxFit.cover,
              //   )
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
    );
  }
}
