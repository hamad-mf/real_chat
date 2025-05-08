import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/SignIn%20Screen/sign_in_screen.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 3;
              });
            },
            children: [
              buildPage(
                image: 'assets/images/GROUP_CHAT.png',
                title: 'Group Chatting',
                subtitle: 'Connect with multiple members in group chats.',
              ),
              buildPage(
                image: 'assets/images/VIDEO_AND_VOICE.png',
                title: 'Video and Voice Calls',
                subtitle: 'Instantly connect via video and voice calls.',
              ),
              buildPage(
                image: 'assets/images/MESSAGE_ENCRYPTION.png',
                title: 'Message Encryption',
                subtitle: 'Ensure privacy with encrypted messages.',
              ),
              buildPage(
                image: 'assets/images/CROSS_PLATFORM.png',
                title: 'Cross-Platform Compatibility',
                subtitle: 'Access chats on any device seamlessly.',
              ),
            ],
          ),
          Positioned(
              bottom: 200,
              left: 20,
              right: 20,
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor:
                          WidgetStatePropertyAll(ColorConstants.ButtonColor1),
                      minimumSize: WidgetStatePropertyAll(Size(
                          ResponsiveHelper.width(345),
                          ResponsiveHelper.height(60)))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ))),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _controller.jumpToPage(2),
                      child: Text("Skip"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (onLastPage) {
                          // Navigate to next screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                        } else {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(onLastPage ? "Get Started" : "Next"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: StadiumBorder(),
                        backgroundColor: Colors.blue,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPage(
      {required String image,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
      child: Column(
        children: [
          Image.asset(image, height: 250),
          SizedBox(height: 30),
          Text(title,
              style: TextStyle(
                  color: ColorConstants.Textbluelight,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConstants.Textbluelight,
            ),
          ),
        ],
      ),
    );
  }
}
