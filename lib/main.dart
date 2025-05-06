import 'package:flutter/material.dart';
import 'package:real_chat/View/Home%20Screen/home_screen.dart';
import 'package:real_chat/View/Splash%20Screen/splash_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
