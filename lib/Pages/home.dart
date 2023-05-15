import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/responses.dart';
import '../store.dart';

class MyStateFulWidget extends StatefulWidget {
  const MyStateFulWidget({super.key});

  @override
  State<MyStateFulWidget> createState() => _MyStateWidgetState();
}

class _MyStateWidgetState extends State<MyStateFulWidget> {
  int _currentIndex = 3;

  static final _TopBar = [
    "Home",
    "Initiative",
    "Frequently Asked Questions",
    "My Profile"
  ];

  static final _bottomNavigationBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/Home.svg"),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/Initiative.svg"),
      label: 'Initiative',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/Faq.svg"),
      label: 'Faq',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/User.svg"),
      label: 'Account',
    ),
  ];

  void changeIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(context) {
    // final UserId = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    final _body = [
      HomeWidget(),
      InitiativeWidget(),
      const FAQWidget(
        questions: [
          QuestionWidget(question: "This is FIRST QUESTION", answers: [
            "To bid in this auction, find your desired lot and choose “Place Bid”.",
            "Select your bid amount. You may either place a bid at the “Next Bid'' option or choose a Maximum Bid amount that the Boundless Giving system will execute on your behalf when competing bids are placed.",
            "You will then be asked to enter your payment information. Your card will not be charged unless you win the item at the end of the auction."
          ]),
          QuestionWidget(question: "This is FIRST QUESTION", answers: [
            "To bid in this auction, find your desired lot and choose “Place Bid”.",
            "Select your bid amount. You may either place a bid at the “Next Bid'' option or choose a Maximum Bid amount that the Boundless Giving system will execute on your behalf when competing bids are placed.",
            "You will then be asked to enter your payment information. Your card will not be charged unless you win the item at the end of the auction."
          ]),
          QuestionWidget(question: "This is FIRST QUESTION", answers: [
            "To bid in this auction, find your desired lot and choose “Place Bid”.",
            "Select your bid amount. You may either place a bid at the “Next Bid'' option or choose a Maximum Bid amount that the Boundless Giving system will execute on your behalf when competing bids are placed.",
            "You will then be asked to enter your payment information. Your card will not be charged unless you win the item at the end of the auction."
          ]),
          QuestionWidget(
              question: "This is SECOND QUESTION",
              answers: ["Answer 1 ", "Answer 2"]),
          QuestionWidget(
              question: "This is THIRD QUESTION",
              answers: ["Answer 1 ", "Answer 2"]),
        ],
      ),
      const AccountWidget()
    ];
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              actions: [
                _currentIndex == 3
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/update-profile',
                          );
                          // Navigator.pushNamed(context, '/update-profile',
                          //     arguments: {
                          //       "UserId": UserId["UserId"],
                          //       "message": UserId["message"]
                          //     });
                        },
                        icon: SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset("assets/svg/settings.svg"),
                        ))
                    : Container()
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/app");
                  },
                  icon: SvgPicture.asset("assets/svg/Vector.svg")),
              backgroundColor: Colors.white,
              title: Text(_TopBar[_currentIndex],
                  style: const TextStyle(
                    color: Colors.black87,
                  ))),
          body: _body[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              iconSize: 20.0,
              type: BottomNavigationBarType.fixed,
              items: _bottomNavigationBar,
              currentIndex: _currentIndex,
              selectedItemColor: const Color.fromRGBO(116, 231, 199, 1),
              onTap: changeIndex)),
      onWillPop: () async {
        String currentRoute = ModalRoute.of(context)!.settings.name!;
        if (currentRoute == '/app') SystemNavigator.pop();
        print("BackButton");
        return true;
      },
    );
  }
}

//HOME WIDGET
class HomeWidget extends StatefulWidget {
  HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int dummyState = 4;

  @override
  Widget build(context) {
    return const Text("Home");
  }
}

//ACCOUNT WIDGET
class AccountWidget extends StatefulWidget {
  // final String message;
  // final String UserId;
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
  late int collectibles = 0;
  late String dollar = '\$';

  @override
  void initState() {
    super.initState();
    // context.watch<User>().userId;
    // print ('By Counter ::::: ${context.watch<User>().userId}');
    // getUserDetails(widget.UserId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = context.watch<User>().userId;
    print("From Inside $userId");
    if (userId.isNotEmpty) getUserDetails(context.watch<User>().userId);
    // }
    // put your logic from initState here
  }

  void getUserDetails(id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await get(Uri.parse(
          'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/users?id=$id'));
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData =
            (UserDetailsResponse.fromJson(jsonDecode(response.body)).data);
        print("skjsdfsdf");
        setState(() {
          profilePicture = jsonData.profilePicture;
          collectibles = jsonData.collectibles.length ?? 0;
          goalsMets = jsonData.goalsMet ?? 0;
          moneyRaised = jsonData.moneyRaised ?? 0;
          name = '${jsonData.firstName} ${jsonData.lastName}';
          location = jsonData.schoolDistrict;
          isLoading = false;
          bio = jsonData.bio ?? '';
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(context) {
    // String profilePicture = context.read<User>().profilePicture;
    // print( 'IMAGE $profilePicture');
    return isLoading
        ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Color.fromRGBO(54, 189, 151, 1),
            ))
        : FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: .4,
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
                                ? Image.network(
                                    profilePicture,
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                  )
                                : Image.asset(
                                    "assets/images/defaultImage.png",
                                    fit: BoxFit.cover,
                                    width: 80.0,
                                    height: 80.0,
                                  )),
                        Column(
                          children: [
                            Text(collectibles.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18)),
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
                                    fontWeight: FontWeight.w700, fontSize: 18)),
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
                                Navigator.pushNamed(context, '/update-profile');
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
            ));
  }
}

// INTIATIVE WIDGET
class InitiativeWidget extends StatefulWidget {
  InitiativeWidget({super.key});

  @override
  State<InitiativeWidget> createState() => _InitiativeWidgetState();
}

class _InitiativeWidgetState extends State<InitiativeWidget> {
  int dummyState = 4;

  @override
  Widget build(context) {
    return const Text("Initiative");
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> answers;
  const QuestionWidget(
      {super.key, required this.question, required this.answers});

  @override
  Widget build(context) {
    return Column(children: [
      const SizedBox(height: 50),
      Align(
        alignment: Alignment.center,
        child: Text(question,
            style: const TextStyle(fontFamily: 'Urbanist', fontSize: 24)),
      ),
      const SizedBox(height: 30),
      ...answers
          .map(
            (e) => Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 50),
                  child: Text(e),
                )),
          )
          .toList()
    ]);
  }
}

class FAQWidget extends StatelessWidget {
  final List<QuestionWidget> questions;
  const FAQWidget({super.key, required this.questions});

  @override
  Widget build(context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions
            .map(
              (e) => e,
            )
            .toList());
  }
}
// class FaqWidget extends StatefulWidget {
//   const FaqWidget({super.key});

//   @override
//   State<FaqWidget> createState() => _FaqWidgetState();
// }

// class _FaqWidgetState extends State<FaqWidget> {
//   bool _isTileExpanded = false;
//   // static final _questions =[{_question : "Questions"}];
//   @override
//   Widget build(context) {
//     return Column(children: <Widget>[
//       Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text("The code word is ‘Rochambeau,’ dig me?",
//               style: DefaultTextStyle.of(context)
//                   .style
//                   .apply(fontSizeFactor: 2.0))),
//       Text("The code word is ‘Rochambeau,’ dig me?"),
//       Text("The code word is ‘Rochambeau,’ dig me?"),
//       Text("The code word is ‘Rochambeau,’ dig me?"),
//     ]);
//   }
// }

// class QuestionBoxWidget extends StatelessWidget {
//   const QuestionBoxWidget ({
//     super.key,
//     this.question = question,
//     this.answer = answer,
//   })
// }
// class Questions {
//   late String question;
//   late Array answer;
// }
// class SingleBox extends StatelessWidget {

//   @override
//   Widget build (context) {

//   }
// }
