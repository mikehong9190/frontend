import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountDetailWidget extends StatelessWidget {
  final String profilePicture;
  final int collectiblesLength;
  final String location;
  final String bio;
  final int moneyRaised;
  final String name;
  final int goalsMets;

  const AccountDetailWidget(
      {super.key,
      required this.profilePicture,
      required this.collectiblesLength,
      required this.location,
      required this.bio,
      required this.moneyRaised,
      required this.name,
      required this.goalsMets});

  @override
  Widget build(context) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: profilePicture.isNotEmpty
                    ? CachedNetworkImage(
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        imageUrl: profilePicture,
                        progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.secondary),
                                  value: downloadProgress.progress),
                            ))
                    : Image.asset(
                        "assets/images/defaultImage.png",
                        fit: BoxFit.cover,
                        width: 80.0,
                        height: 80.0,
                      ),
              ),
              Column(
                children: [
                  Text(collectiblesLength.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18)),
                  const Text(
                    "Collectibles",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(183, 183, 183, 1)),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "\$ $moneyRaised",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const Text(
                    'Money Raised',
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(183, 183, 183, 1)),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(goalsMets.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18)),
                  const Text('Goals Met',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(183, 183, 183, 1)))
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.bottomLeft,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.bottomLeft,
            child: Row(children: [
              SvgPicture.asset("assets/svg/location.svg"),
              const SizedBox(
                width: 2,
              ),
              Text(
                location,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              )
            ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.bottomLeft,
            child: bio.isEmpty
                ? null
                // TextButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/update-profile');
                //     },
                //     child: const Text(
                //       "Add Bio",
                //       style: TextStyle(color: Colors.black),
                //     ),
                //   )
                : Text(bio),
          ),
        ]),
      ),
    );
  }
}
