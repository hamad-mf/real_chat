import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Get%20Started%20Screen/get_started_screen.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    width: ResponsiveHelper.width(82),
                    image: AssetImage('assets/images/LOGO_DARK.png')),
                SizedBox(
                  width: ResponsiveHelper.width(20),
                ),
                Text(
                  "Real Chat",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: ColorConstants.Textblue),
                ),
              ],
            )),
            SizedBox(
              height: ResponsiveHelper.height(150),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetStartedScreen(),
                    ));
              },
              child: Stack(children: [
                Image(image: AssetImage('assets/images/ONBOARDING_LOGO.png')),
                Positioned(
                    left: 50,
                    top: 110,
                    child: Column(
                      children: [
                        Text(
                          "Stay Connected",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: ColorConstants.Textbluelight),
                        ),
                        Text(
                          "Stay Chatting",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: ColorConstants.Textbluelight),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 35,
                          color: ColorConstants.Textbluelight,
                        )
                      ],
                    )),
              ]),
            ),
            SizedBox(
              height: 210,
            ),
            Text(
              "Version 1.0.0",
              style: TextStyle(
                  color: ColorConstants.Textbluelight,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
