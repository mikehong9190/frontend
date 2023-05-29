import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/responses.dart';
import '../store.dart';
import './home.dart';
import '../constants.dart';
import '../components/collectibles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({
    super.key,
    // required this.UserId,
    // required this.message
  });

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  bool isLoading = false;
  late String name = '';
  late String profilePicture = '';
  late String location = '';
  late String bio = '';
  late int goalsMets = 0;
  late int moneyRaised = 0;
  late List collectibles = [];
  late String dollar = '\$';

  @override
  void initState() {
    super.initState();
    // context.watch<User>().userId;
    // log ('By Counter ::::: ${context.watch<User>().userId}');
    // getUserDetails(widget.UserId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.watch<User>().userId;
    log("From Inside $userId");
    if (userId.isNotEmpty) getUserDetails(context.watch<User>().userId);
    // }
    // put your logic from initState here
  }

  void getUserDetails(id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final queryParameters = {"id": id};
      final response =
          await get(Uri.https(apiHost, '/v1/users', queryParameters));
      if (response.statusCode == 200) {
        final jsonData =
            (UserDetailsResponse.fromJson(jsonDecode(response.body)).data);

        setState(() {
          profilePicture = jsonData.profilePicture;
          collectibles = jsonData.collectibles ?? [];
          goalsMets = jsonData.goalsMet ?? 0;
          moneyRaised = jsonData.moneyRaised ?? 0;
          name = '${jsonData.firstName} ${jsonData.lastName}';
          location = jsonData.schoolDistrict;
          bio = jsonData.bio ?? '';
        });
      }
    } catch (error) {
      log(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(context) {
    // String profilePicture = context.read<User>().profilePicture;
    // log( 'IMAGE $profilePicture');
    return isLoading
        ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(54, 189, 151, 1),
            ))
        : Column(
            children: [
              SizedBox(
                  // alignment: Alignment.topCenter,
                  // heightFactor: .7,
                  child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color.fromRGBO(
                                                            54, 189, 151, 1)),
                                                value:
                                                    downloadProgress.progress),
                                          ))
                                  // Image.network(
                                  //     profilePicture,
                                  //     fit: BoxFit.cover,
                                  //     width: 80.0,
                                  //     height: 80.0,
                                  //   )
                                  : Image.asset(
                                      "assets/images/defaultImage.png",
                                      fit: BoxFit.cover,
                                      width: 80.0,
                                      height: 80.0,
                                    )),
                          Column(
                            children: [
                              Text(collectibles.length.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              const Text(
                                "Collectibles",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(183, 183, 183, 1)),
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
                                    fontSize: 12,
                                    color: Color.fromRGBO(183, 183, 183, 1)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(goalsMets.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              const Text('Goals Mets',
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
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.bottomLeft,
                        child: Row(children: [
                          SvgPicture.asset("assets/svg/location.svg"),
                          Text(
                            location,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          )
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.bottomLeft,
                        child: bio.isEmpty
                            ? TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/update-profile');
                                  // Navigator.pushNamed(context, '/update-profile',
                                  //     arguments: {
                                  //       "UserId": widget.UserId,
                                  //       "message": widget.message
                                  //     });
                                },
                                child: const Text(
                                  "Add Bio",
                                  style: TextStyle(color: Colors.black),
                                ))
                            : Text(bio),
                      ),
                    ]),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GridView.builder(
                    itemCount: collectibles.length,
                    scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            // crossAxisSpacing: 10,
                            // mainAxisSpacing: 10,
                            maxCrossAxisExtent: 220),
                    itemBuilder: (_, index) {
                      return Center(
                          child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Collectibles"),
                                  content: collectibles[index].isNotEmpty
                                      ? Image.network(
                                          collectibles[index],
                                          width: 500,
                                          height: 500,
                                        )
                                      : Image.asset(
                                          "assets/images/defaultImage.png",
                                          width: 500,
                                          height: 500,
                                        ),
                                );
                              });
                        },
                        child: CollectiblesWidget(
                          collectibleImage: collectibles[index],
                        ),
                      ));
                    }),
              ))
            ],
          );
    ;
  }
}
