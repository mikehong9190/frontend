import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/initiative.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/responses.dart';
import '../store.dart';
import './home.dart';
import './account.dart';
import '../constants.dart';

class MyStateFulWidget extends StatefulWidget {
  const MyStateFulWidget({super.key});

  @override
  State<MyStateFulWidget> createState() => _MyStateWidgetState();
}

class _MyStateWidgetState extends State<MyStateFulWidget> {
  bool isLoading = false;
  int _currentIndex = 0;
  String schoolId = '';
  String schoolName = '';
  String schoolLocation = '';
  static final topBar = [
    "Home",
    "Initiative",
    "Frequently Asked Questions",
    "My Profile"
  ];
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
          await get(Uri.https(apiHost, '/v1/user/get-all', queryParameters));
      if (response.statusCode == 200) {
        final jsonData =
            (UserDetailsResponse.fromJson(jsonDecode(response.body)).data);
        setState(() {
          schoolId = jsonData.schoolId;
          schoolName = jsonData.schoolName;
          schoolLocation = jsonData.schoolDistrict;
        });
      }
    } catch (error, stackTrace) {
      // print(stackTrace);
      log(stackTrace.toString());
      log(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
    final body = [
      HomeWidget(
          schoolId: schoolId,
          schoolName: schoolName,
          schoolLocation: schoolLocation),
      const Initiative(),
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
              leading: _currentIndex != 0
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/app");
                      },
                      icon: SvgPicture.asset("assets/svg/Vector.svg"))
                  : Container(),
              backgroundColor: Colors.white,
              title: Text(topBar[_currentIndex],
                  style: const TextStyle(
                    color: Colors.black87,
                  ))),
          body: isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ))
              : body[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              iconSize: 20.0,
              type: BottomNavigationBarType.fixed,
              items: _bottomNavigationBar,
              currentIndex: _currentIndex,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              onTap: changeIndex)),
      onWillPop: () async {
        String currentRoute = ModalRoute.of(context)!.settings.name!;
        if (currentRoute == '/app') SystemNavigator.pop();
        log("BackButton");
        return true;
      },
    );
  }
}

//HOME WIDGET

//ACCOUNT WIDGET

class InitiativeWidget extends StatefulWidget {
  const InitiativeWidget({super.key});

  @override
  State<InitiativeWidget> createState() => _InitiativeWidgetState();
}

class _InitiativeWidgetState extends State<InitiativeWidget> {
  int dummyState = 0;

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
        alignment: Alignment.topLeft,
        child: Text(question,
            style: const TextStyle(fontFamily: 'Urbanist', fontSize: 24)),
      ),
      const SizedBox(height: 30),
      ...answers
          .map(
            (e) => Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 0),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: questions
              .map(
                (e) => e,
              )
              .toList()),
    );
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
