import 'package:flutter/material.dart';
import 'package:foodie/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie',
      theme: ThemeData(
        fontFamily: 'Quicksand Bold',
        primaryColor: Colors.white
      ),
      home: new Scaffold(
        body: new WelcomeScreen(),
      ),
    );
  }
}
