import 'package:flutter/material.dart';
// import 'package:frontend/Pages/home.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/app.dart';
// import 'package:frontend/Pages/forget_password.dart';
import 'Pages/forget_password.dart';
import 'package:frontend/Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store.dart';
import 'Pages/welcome.dart';
import 'Pages/get_started.dart';
import 'Pages/registration.dart';
import 'Pages/update_profile.dart';
import 'Pages/registration_pages.dart';
import 'Pages/reset_password.dart';
// import 'Pages/camera.dart';

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
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // String? userId = prefs.getString("userId")!;
  String initialRoute = isFirstTime
      ? '/'
      : isLoggedIn
          ? '/app'
          : '/login';

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
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(context) {
    if (initialRoute == "/app") context.read<User>().getUserDataFromLocal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swirl.io',
      theme: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              secondary: Color.fromRGBO(54, 189, 151, 1)),
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
        '/forget-password': (context) => const ForgetPasswordWidget(),
        '/login': (context) => const LoginWidget(),
        // Add more routes as needed
      },
    );
  }
}
