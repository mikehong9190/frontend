import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/home.dart';
import 'package:frontend/Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store.dart';

import 'Pages/Welcome.dart';
import 'Pages/getStarted.dart';
// import 'components/TextField.dart';
import 'Pages/Registration.dart';
// import 'Pages/login.dart';
import 'Pages/UpdateProfile.dart';
import 'Pages/RegistrationPages.dart';
import 'Pages/ResetPassword.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      // Remove the previous route from the history
      navigator?.removeRouteBelow(previousRoute);
    }
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('userLoggedIn') ?? false;
  // String? userId = prefs.getString("userId")!;
  String initialRoute = isLoggedIn ? '/app' : '/';

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => User(),
      )
    ],
    child: MyApp(initialRoute: initialRoute),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute});

  @override
  Widget build(context) {
    if (initialRoute == "/app") context.read<User>().getUserDataFromLocal();
    return MaterialApp(
// <<<<<<< ui-changes
//         title: 'Swirl.io',
//         theme: ThemeData.light().copyWith(
//             textTheme:
//                 GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)),
//         // home: MyStateFulWidget(),
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const WelcomeWidget(),
//           '/getStarted': (context) => const GettingStartedWidget(),
//           '/registration': (context) => const RegistrationWidget(),
//           '/app': (context) => const MyStateFulWidget(),
//           '/update-profile': (context) => UpdateProfileWidget(),
//           '/google-auth-school': (context) => const GoogleAuthWidget(),
//           '/reset-password': (context) => const ResetPasswordWidget()
//         });
// =======
      title: 'Swirl.io',
      theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme),
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)))),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const WelcomeWidget(),
        '/getStarted': (context) => const GettingStartedWidget(),
        '/registration': (context) => const RegistrationWidget(),
        '/app': (context) => const MyStateFulWidget(),
        '/update-profile': (context) => UpdateProfileWidget(),
        '/google-auth-school': (context) => const GoogleAuthWidget(),
        '/reset-password': (context) => const ResetPasswordWidget(),
        '/login': (context) => const LoginWidget(),
        // Add more routes as needed
      },
    );
// >>>>>>> dev
  }
}

Widget SetupInitiativeWidget(value12) {
  return Center(
    child: Column(children: [
      const Text(
        "Set up your initiative",
        style: TextStyle(fontSize: 24),
      ),
      const SizedBox(
        height: 20,
      ),
      const SizedBox(
        height: 30,
        width: 350,
        child: Text("What are you fundraising for"),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 500,
        child: Column(children: [
          ListTile(
            title: const Text('Computer Lab Equipment'),
            leading: const Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          ListTile(
            title: const Text('Science Lab Equipment'),
            leading: const Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          ListTile(
            title: const Text('Art Supplies'),
            leading: const Icon(Icons.adobe_rounded),
            trailing: Radio<SingingCharacter>(
                value: SingingCharacter.lafayette,
                groupValue: value12,
                onChanged: (SingingCharacter) {
                  print("asdadd");
                }),
          ),
          const SizedBox(
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
// <<<<<<< ui-changes
//                 child: const Text("Next"),
// =======
// >>>>>>> dev
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(54, 189, 151, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)))),
                onPressed: () {
                  print("asd");
                },
                child: const Text("Next"),
              )),
        ),
      )
    ]),
  );
}
