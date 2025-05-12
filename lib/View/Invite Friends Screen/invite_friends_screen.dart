import 'dart:developer';

import 'package:flutter/material.dart';

class InviteFriendsScreen extends StatelessWidget {
  InviteFriendsScreen({super.key});

  final List<SocialMediaApp> socialApps = [
    SocialMediaApp(
      name: 'Twitter',
      imgUrl: 'assets/images/twitter.png',
      onTap: () => log('Twitter tapped'),
    ),
    SocialMediaApp(
      name: 'Facebook',
      imgUrl: 'assets/images/Facebook.png',
      onTap: () => log('Facebook tapped'),
    ),
    SocialMediaApp(
      name: 'Messenger',
      imgUrl: 'assets/images/Messenger.png',
      onTap: () => log('Messenger tapped'),
    ),
    SocialMediaApp(
      name: 'Discord',
      imgUrl: 'assets/images/Discord.png',
      onTap: () => log('Discord tapped'),
    ),
    SocialMediaApp(
      name: 'Skype',
      imgUrl: 'assets/images/Skype.png',
      onTap: () => log('Skype tapped'),
    ),
    SocialMediaApp(
      name: 'Telegram',
      imgUrl: 'assets/images/Telegram.png',
      onTap: () => log('Telegram tapped'),
    ),
    SocialMediaApp(
      name: 'WeChat',
      imgUrl: 'assets/images/Weechat.png',
      onTap: () => log('WeChat tapped'),
    ),
    SocialMediaApp(
      name: 'WhatsApp',
      imgUrl: 'assets/images/Whatsapp.png',
      onTap: () => log('WhatsApp tapped'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Invite Friends",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz_outlined,
                  size: 35,
                ))
          ],
        ),
        body: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 220),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Show 4 icons per row
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            itemCount: socialApps.length,
            itemBuilder: (context, index) {
              return SocialMediaAppContainer(
                socialApp: socialApps[index],
              );
            },
          ),
        ));
  }
}

class SocialMediaApp {
  final String name;

  final String imgUrl;
  final VoidCallback onTap;

  SocialMediaApp({
    required this.imgUrl,
    required this.name,
    required this.onTap,
  });
}

class SocialMediaAppContainer extends StatelessWidget {
  final SocialMediaApp socialApp;

  const SocialMediaAppContainer({
    Key? key,
    required this.socialApp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: socialApp.onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(socialApp.imgUrl))),
      ),
    );
  }
}
