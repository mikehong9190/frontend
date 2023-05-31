// import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CollectiblesWidget extends StatelessWidget {
  final dynamic collectibleImage;
  final double dimension;
  const CollectiblesWidget(
      {super.key, this.collectibleImage, required this.dimension});

  @override
  Widget build(context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: collectibleImage.isNotEmpty
              ? FancyShimmerImage(
                  imageUrl: collectibleImage,
                  width: dimension,
                  height: dimension,
                  boxFit: BoxFit.fill)
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
              //                   Theme.of(context).colorScheme.secondary),
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
