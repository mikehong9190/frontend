import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Swirl.io',
      home: MyStateFulWidget(),
    );
  }
}

class MyStateFulWidget extends StatefulWidget {
  const MyStateFulWidget({super.key});

  @override
  State<MyStateFulWidget> createState() => _MyStateWidgetState();
}

class _MyStateWidgetState extends State<MyStateFulWidget> {
  int _currentIndex = 0;

  static final _body = [HomeWidget(), InitiativeWidget(), FaqWidget(), AccountWidget()];
  static final _TopBar = ["HOME", "NAVIGATION", "Frequently Asked Questions", "ACCOUNT"];
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
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: GestureDetector(
                onTap: () {}, child: SvgPicture.asset("assets/svg/Vector.svg")),
            leadingWidth: 10,
            backgroundColor: Colors.white,
            titleSpacing: 50,
            title: Text(_TopBar[_currentIndex],
                style: TextStyle(
                  color: Colors.black87,
                ))),
        body: _body[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 20.0,
            type: BottomNavigationBarType.fixed,
            items: _bottomNavigationBar,
            currentIndex: _currentIndex,
            selectedItemColor: Color.fromRGBO(116, 231, 199, 1),
            onTap: changeIndex));
  }
}
//HOME WIDGET
class HomeWidget extends StatefulWidget {
  HomeWidget ({super.key});

  @override
  State<HomeWidget> createState () => _HomeWidgetState ();
}

class _HomeWidgetState extends State<HomeWidget> {
  int dummyState = 4;

  @override 
  Widget build (context) {
    return const Text("Home");
  }
}
//ACCOUNT WIDGET
class AccountWidget extends StatefulWidget {
  AccountWidget ({super.key});

  @override
  State<AccountWidget> createState () => _AccountWidgetState ();
}

class _AccountWidgetState extends State<AccountWidget> {
  int dummyState = 4;

  @override 
  Widget build (context) {
    return const Text("Account");
  }
}
// INTIATIVE WIDGET
class InitiativeWidget extends StatefulWidget {
  InitiativeWidget ({super.key});

  @override
  State<InitiativeWidget> createState () => _InitiativeWidgetState ();
}

class _InitiativeWidgetState extends State<InitiativeWidget> {
  int dummyState = 4;

  @override 
  Widget build (context) {
    return const Text("Initiative");
  }
}

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool _isTileExpanded = false;
  // static final _questions =[{_question : "Questions"}];
  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(16.0),child : Text ("The code word is ‘Rochambeau,’ dig me?",style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0))),
        Text ("The code word is ‘Rochambeau,’ dig me?"),
        Text ("The code word is ‘Rochambeau,’ dig me?"),
        Text ("The code word is ‘Rochambeau,’ dig me?"),
      ]
    );
  }
}

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