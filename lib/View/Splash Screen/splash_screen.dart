import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:real_chat/View/On%20Boarding%20Screen/on_boarding_screen.dart';
import 'package:real_chat/View/Set%20Pin%20Screen/set_pin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    
  }

  // Method to check user login status
  void _checkLoginStatus() async {
    log("checking login status");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check both user and admin login statuses
    bool isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Wait for 4 seconds, then navigate based on login status
    Timer(Duration(seconds: 4), () {
      if (isUserLoggedIn) {
        // Navigate to
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => SetPinScreen()));
      } else {
        // Navigate to onBoarding screen
        log("false");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnBoardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Image(image: AssetImage('assets/images/LOGO_DARK.png'))],
        ),
      ),
    );
  }
}
