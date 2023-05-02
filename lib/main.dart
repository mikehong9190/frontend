import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  print(SvgPicture.asset("assets/svg/idea.svg"));
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

  static const _body = ["HOME", "NAVIGATION", "FAQ", "ACCOUNT"];
  static const _TopBar = ["HOME", "NAVIGATION", "FAQ", "ACCOUNT"];
  static final _bottomNavigationBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/idea.svg"),
      label: 'Initiative',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/Vector.svg"),
      label: 'Faq',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset("assets/svg/iconUser.svg"),
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
            leading: GestureDetector(
                onTap: () {}, child: SvgPicture.asset("assets/svg/backButton.svg")),
            backgroundColor: Colors.white,
            title: const Text("Frequently Asked Questions",style: TextStyle(color: Colors.black87,

  ))),
        body: const FaqWidget(),
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 20.0,
            type: BottomNavigationBarType.fixed,
            items: _bottomNavigationBar,
            currentIndex: _currentIndex,
            selectedItemColor: Color.fromRGBO(116, 231, 199, 1),
            onTap: changeIndex));
  }
}

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool _isTileExpanded = false;

  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('Question 1'),
          subtitle: Text('Answer 1'),
          children: <Widget>[
            ListTile(title: Text('This is Answer 1')),
          ],
        ),
        ExpansionTile(
          title: Text('Question 2'),
          subtitle: Text('Answer 2'),
          children: <Widget>[
            ListTile(title: Text('This is Answer 2')),
          ],
        ),
      ],
    );
  }
}
