import 'package:calendarapp/screens/home_screen.dart';
import 'package:calendarapp/screens/login_screen.dart';
import 'package:calendarapp/screens/phone_login.dart';
import 'package:calendarapp/screens/signup_screen.dart';
import 'package:calendarapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/phoneLogin': (context) => PhoneAuthScreen(),
      },
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[800],
        hintColor: Colors.tealAccent,
        cardColor: Colors.black87,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white70),
          bodyText2: TextStyle(color: Colors.white54),
        ),
        // Additional dark theme customizations
      ),
      title: 'Calendar',
      home: const SplashScreen(),
    );
  }
}
