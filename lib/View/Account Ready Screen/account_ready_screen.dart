import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:real_chat/View/Widgets/custom_bottom_navbar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccountReadyScreen extends StatefulWidget {
  const AccountReadyScreen({super.key});

  @override
  State<AccountReadyScreen> createState() => _AccountReadyScreenState();
}

class _AccountReadyScreenState extends State<AccountReadyScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), () async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomBottomNavbarScreen()), // Replace this with your actual screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image or content
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/CONGRATULATIONS.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Center Card/Modal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Congratulations!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Image.asset('assets/images/CONGRATULATIONS.png',
                          height: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Your account is now ready to use.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You will be redirected to the Home page shortly.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const CircularProgressIndicator()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
