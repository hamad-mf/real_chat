import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "About App",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(child: Image.asset('assets/images/LOGO_DARK.png')),
            SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment(0.1, 0),
              child: Text(
                "Real Chat",
                style: TextStyle(
                    color: ColorConstants.Textblue,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment(0.1, 0),
              child: Text(
                "Vserion 1.0.0",
                style: TextStyle(
                    color: ColorConstants.Textblue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                    backgroundColor:
                        WidgetStatePropertyAll(ColorConstants.ButtonColor1),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 56))),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ResponsiveHelper.width(16),
                    ),
                    Text(
                      "Other Apps",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
