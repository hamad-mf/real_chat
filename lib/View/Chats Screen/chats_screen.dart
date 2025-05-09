import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Real Chat",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20),
        ),
        backgroundColor: ColorConstants.AppBarBlue,
        actions: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: ResponsiveHelper.width(15),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: ResponsiveHelper.width(15),
              ),
            ],
          )
        ],
        leading: Image.asset('assets/images/LOGO_LITE.png'),
      ),
      body: Column(
        children: [
          Center(
            child: Text("Chat screen"),
          )
        ],
      ),
    );
  }
}
