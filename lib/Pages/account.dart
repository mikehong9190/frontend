import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/responses.dart';
import '../store.dart';
// import './home.dart';
import '../constants.dart';
import '../components/collectibles.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import '../components/account_details.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({
    super.key,
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
  final scrollController = ScrollController();
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
      final response = await get(
          Uri.https(apiHost, '/v1/user/get-all', queryParameters));
      print(response.statusCode);
      print(response.body);
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
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                AccountDetailWidget(
                    profilePicture: profilePicture,
                    collectiblesLength: collectibles.length,
                    location: location,
                    bio: bio,
                    moneyRaised: moneyRaised,
                    name: name,
                    goalsMets: goalsMets),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Divider(
                    color: Color.fromARGB(255, 70, 69, 69),
                    thickness: 0.1,
                  ),
                ),
                collectibles.isEmpty
                    ? const Center(
                        child: Text(
                          'No initiatives added yet',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 196, 196, 196)),
                        ),
                      )
                    : SizedBox(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: collectibles.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    maxCrossAxisExtent: 220),
                            itemBuilder: (_, index) {
                              return
                                  // Center(
                                  //     child:
                                  GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          insetPadding: EdgeInsets.zero,
                                          title: const Text("Collectibles"),
                                          content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            child:
                                                collectibles[index].isNotEmpty
                                                    ? FancyShimmerImage(
                                                        imageUrl:
                                                            collectibles[index],
                                                        boxFit: BoxFit.contain,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/defaultImage.png",
                                                        width: 600,
                                                        height: 600,
                                                      ),
                                          ),
                                        );
                                      });
                                },
                                child: CollectiblesWidget(
                                  collectibleImage: collectibles[index],
                                  dimension: 160,
                                ),
                              );
                              // );
                            }),
                      ))
              ],
            ),
          );
  }
}
