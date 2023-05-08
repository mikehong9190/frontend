import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/TextField.dart';
import 'Pages/Registration.dart';
import 'Pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Swirl.io',
      theme: ThemeData.light().copyWith(
          textTheme:
              GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)),
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

  static final _body = [
    HomeWidget(),
    InitiativeWidget(),
    const FAQWidget(
      questions: [
        QuestionWidget(
            question: "This is FIRST QUESTION",
            answers: ["Answer 1 ", "Answer 2"]),
        QuestionWidget(
            question: "This is SECOND QUESTION",
            answers: ["Answer 1 ", "Answer 2"]),
        QuestionWidget(
            question: "This is THIRD QUESTION",
            answers: ["Answer 1 ", "Answer 2"]),
      ],
    ),
    AccountWidget()
  ];

  static final _TopBar = [
    "Home",
    "Initiative",
    "Frequently Asked Questions",
    "Account"
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
    // return LoginWidget();
    return RegistrationWidget();
    // return FirstPageWidget();
    // return GettingStartedWidget();
    // return WelcomeWidget();
    // return Scaffold(
    //     appBar: AppBar(
    //         centerTitle: true,
    //         elevation: 0,
    //         leading: IconButton(
    //             onPressed: () {
    //               print("Will navigate to original position ");
    //             },
    //             icon: SvgPicture.asset("assets/svg/Vector.svg")),
    //         backgroundColor: Colors.white,
    //         title: Text(_TopBar[_currentIndex],
    //             style: TextStyle(
    //               color: Colors.black87,
    //             ))),
    //     body: _body[_currentIndex],
    //     bottomNavigationBar: BottomNavigationBar(
    //         iconSize: 20.0,
    //         type: BottomNavigationBarType.fixed,
    //         items: _bottomNavigationBar,
    //         currentIndex: _currentIndex,
    //         selectedItemColor: Color.fromRGBO(116, 231, 199, 1),
    //         onTap: changeIndex));
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
  AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  int dummyState = 4;

  @override
  Widget build(context) {
    return const Text("Account");
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

// FAQ WIDGET
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

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Opacity(
                        opacity: 1,
                        child: Image.asset("assets/images/cover.png",
                            fit: BoxFit.cover))),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Image.asset("assets/images/swiirl.png"),
                        SizedBox(
                          height: 50,
                        ),
                        SvgPicture.asset("assets/svg/Button.svg"),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Artfully Funding the Future',
                            style: TextStyle(color: Colors.white)),
                      ]),
                )
              ],
            )));
  }
}

class GettingStartedWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
        body: Container(
            child: Stack(children: [
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Image.asset("assets/images/Mockup.jpg"),
          SizedBox(
            height: 50,
          ),
          Text(
            "Take a picture and rewrite the story",
            style: TextStyle(fontSize: 24, fontFamily: "Bold/Type@24"),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Art to Digital Collectibles in a single click",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 50,
          ),
          ClipOval(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Color.fromRGBO(54, 189, 151, 1),
                  child: Text('Start'),
                  alignment: Alignment.center))
        ],
      ))
    ])));
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
      SizedBox(height: 50),
      Text(question, style: TextStyle(fontFamily: 'Urbanist', fontSize: 24)),
      SizedBox(height: 30),
      ...answers
          .map(
            (e) => Text(e),
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
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: questions
            .map(
              (e) => e,
            )
            .toList());
  }
}

// class RegistrationWidget extends StatefulWidget {
//   const RegistrationWidget({super.key});

//   @override
//   State<RegistrationWidget> createState() => _RegistrationWidgetState();
// }

// enum SingingCharacter { lafayette, jefferson }

// class _RegistrationWidgetState extends State<RegistrationWidget> {
//   final currentStage = "firstPage";
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final emailController = TextEditingController();
//   SingingCharacter? _character = SingingCharacter.jefferson;

//   @override
//   void initState() {
//     super.initState();
//     emailController.addListener(() {
//       setState(
//         () {},
//       );
//     });
//   }

//   @override
//   Widget build(context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//         ),
//         body: FirstPageWidget(emailController)
//         // body: SecondPageWidget(passwordController, confirmPasswordController),
//         // body: SetupInitiativeWidget(_character)
//         // body: SecondPageWidget()
//         );
//   }
// }

Widget SetupInitiativeWidget(value12) {
  return Center(
    child: Column(children: [
      Text(
          "Set up your initiative",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 30,
          width: 350,
          child: Text(
              "What are you fundraising for"),
        ),
        SizedBox(
          height: 10,
        ),
      SizedBox(
        height: 500,
        child: Column(children: [
          ListTile(
            title: const Text('Computer Lab Equipment'),
            leading: Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          ListTile(
            title: const Text('Science Lab Equipment'),
            leading: Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          ListTile(
            title: const Text('Art Supplies'),
            leading: Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                // controller: controller,
                // obscureText: isPassword,
                decoration: InputDecoration(
                  // suffixIcon: isPassword
                  //     ? IconButton(
                  //         onPressed: () {},
                  //         icon: SvgPicture.asset("assets/svg/Eye.svg"))
                  //     : Container(
                  //         width: 0,
                  //       ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  hintText: "Others",
                ),
              ))
        ]),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          child: SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                child: Text("Next"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(54, 189, 151, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)))),
                onPressed: () {
                  print("asd");
                },
              )),
        ),
      )
    ]),
  );
}

Widget FirstPageWidget(controller) {
  return Center(
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text(
          "Enter your email address",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 30,
          width: 350,
          child: Text(
              "Sign in with our email. If you don’t have a swiirl account yet, we’ll get one set up."),
        ),
        SizedBox(
          height: 50,
        ),
        TextFieldWidget("Your Email", controller, false),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ButtonTheme(
            child: SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  child: Text("Next"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(54, 189, 151, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)))),
                  onPressed: () {
                    print("asd");
                  },
                )),
          ),
        ),
        OAuthButtonWidget(content: "Continue with Google", iconUrl: "URL"),
        OAuthButtonWidget(content: "Continue with Facebook", iconUrl: "URL"),
        OAuthButtonWidget(content: "Continue with Apple", iconUrl: "URL"),
        SizedBox(
          height: 50,
        ),
        SizedBox(
          width: 350,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/images/swiirl-S-Mark-Aqua-Dot 4.png"),
          ),
        )
      ]));
}

class OAuthButtonWidget extends StatelessWidget {
  final String content;
  final String iconUrl;

  OAuthButtonWidget({super.key, required this.content, required this.iconUrl});

  @override
  Widget build(context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
            width: 350,
            height: 50,
            child: OutlinedButton(
                child: Text(
                  content,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  print("Pringf ::");
                })),
      ],
    );
  }
}

Widget SecondPageWidget(controller1, controller2) {
  return Center(
    child: Column(
      children: [
        Text(
          "Create Your Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Must be 8 character or longer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        TextFieldWidget("Password", controller1, true),
        SizedBox(
          height: 10,
        ),
        TextFieldWidget("Confirm New Password", controller2, true),
        SizedBox(
          height: 30,
        ),
        ButtonTheme(
          child: SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                child: Text("Next"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(54, 189, 151, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)))),
                onPressed: () {
                  print(controller1.text);
                  print(controller2.text);
                },
              )),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 30,
          child:
              Text("Please agree to swiirl’s Term of Use and Privacy Policy,"),
        )
      ],
    ),
  );
}

// Widget ThirdPageWidget () {
//     return Center(
//       child: Column(
//         children: [
//           Text(
//             "Resgistration Details",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Text("This is used to build your profile on swiirl",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
//           SizedBox(height: 30),
//           TextFieldWidget(
//             "Full Name",
//           ),
//           TextFieldWidget(
//             "School District",
//           ),
//           TextFieldWidget("School Name"),
//           TextFieldWidget("Grade or Class Name"),
//           TextFieldWidget("Number of Students"),
//           SizedBox(
//             height: 60,
//           ),
//           ButtonTheme(
//             child: SizedBox(
//                 height: 50,
//                 width: 350,
//                 child: ElevatedButton(
//                   child: Text("Next"),
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           Color.fromRGBO(54, 189, 151, 1)),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0)))),
//                   onPressed: () {},
//                 )),
//           ),
//         ],
//       ),
//     );
//   }


// Widget TextFieldWidget(label, controller, isPassword) {
//   // final String label;
//   // TextFieldWidget ({super.key,required this.label,});
//   return Column(
//     children: [
//       SizedBox(
//         height: 30,
//         width: 350,
//         child: Align(
//             alignment: AlignmentDirectional.bottomStart,
//             child: Text(label,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontWeight: FontWeight.w500))),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//       SizedBox(
//           height: 50,
//           width: 350,
//           child: TextField(
//             controller: controller,
//             obscureText: isPassword,
//             decoration: InputDecoration(
//               suffixIcon: isPassword
//                   ? IconButton(
//                       onPressed: () {},
//                       icon: SvgPicture.asset("assets/svg/Eye.svg"))
//                   : Container(
//                       width: 0,
//                     ),
//               border: OutlineInputBorder(borderRadius: BorderRadius.zero),
//               hintText: !isPassword ? 'youremail@email.xyz' : "**********",
//             ),
//           )),
//     ],
//   );
// }
