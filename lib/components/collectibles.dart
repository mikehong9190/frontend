import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CollectiblesWidget extends StatelessWidget {
  final dynamic collectibleImage;
  const CollectiblesWidget({super.key, this.collectibleImage});

  @override
  Widget build(context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: collectibleImage.isNotEmpty
              ? FancyShimmerImage(imageUrl: collectibleImage,width: 150,height: 150,)
              // CachedNetworkImage(
              //     width: 150,
              //     height: 150,
              //     fit: BoxFit.cover,
              //     imageUrl: collectibleImage,
              //     progressIndicatorBuilder: (context, url, downloadProgress) =>
              //         SizedBox(
              //           width: 80,
              //           height: 80,
              //           child: CircularProgressIndicator(
              //               valueColor: const AlwaysStoppedAnimation<Color>(
              //                   Color.fromRGBO(54, 189, 151, 1)),
              //               value: downloadProgress.progress),
              //         ))
              : Image.asset(
                  "assets/images/defaultImage.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
        ),
      ],
    );
  }
}
