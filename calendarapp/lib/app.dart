import 'package:flutter/material.dart';
import 'package:calendarapp/screens/HomeScreen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(),
    );
  }
}
