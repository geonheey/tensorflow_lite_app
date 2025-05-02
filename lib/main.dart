import 'package:flutter/material.dart';
import 'screens/movenet_app.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoveNetApp(),
    );
  }
}