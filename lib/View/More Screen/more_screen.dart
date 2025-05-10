import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/On%20Boarding%20Screen/on_boarding_screen.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              AppBar(
                title: const Text(
                  "Real Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: ColorConstants.AppBarBlue,
                leading: Image.asset('assets/images/LOGO_LITE.png'),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showPopup = !showPopup;
                      });
                    },
                    icon: Icon(showPopup ? Icons.close : Icons.add),
                    iconSize: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: ResponsiveHelper.width(15)),
                ],
              ),
              Expanded(
                child: Center(
                    child: InkWell(
                        onTap: () {
                          log("tapped");
                        },
                        child: Text("More screen"))),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool(
                        'isLoggedIn', false); // Set isLoggedIn to false
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => OnBoardingScreen()),
                    );
                  },
                  child: Text("logout"))
            ],
          ),

          // Outside tap dismiss area
          if (showPopup)
            GestureDetector(
              onTap: () {
                setState(() {
                  showPopup = false;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),

          // Popup menu
          if (showPopup)
            Positioned(
              top: kToolbarHeight + 12,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_add),
                        title: const Text('Add Friend'),
                        onTap: () {
                          // Handle action
                          setState(() => showPopup = false);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.group_add),
                        title: const Text('Create Group'),
                        onTap: () {
                          // Handle action
                          setState(() => showPopup = false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
