import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/app.dart';
import 'package:frontend/Pages/forgetPassword.dart';
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
          inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)))),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const WelcomeWidget(),
        '/getStarted': (context) => const GettingStartedWidget(),
        '/registration': (context) => const RegistrationWidget(),
        '/app': (context) => const MyStateFulWidget(),
        '/update-profile': (context) => const UpdateProfileWidget(),
        '/google-auth-school': (context) => const GoogleAuthWidget(),
        '/reset-password': (context) => const ResetPasswordWidget(),
        '/forget-password' : (context) => const ForgetPasswordWidget(),
        '/login': (context) => const LoginWidget(),
        // Add more routes as needed
      },
    );
// >>>>>>> dev
  }
}

