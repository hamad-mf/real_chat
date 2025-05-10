import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';

import 'package:real_chat/View/Widgets/responsive_helper.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "name": 'Language',
        'image': 'assets/images/lang.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Dark Mode',
        'image': 'assets/images/moon.png',
        'trailing': 'switch'
      },
      {
        "name": 'Mute Notification',
        'image': 'assets/images/mute.png',
        'trailing': 'switch'
      },
      {
        "name": 'Custom Notification',
        'image': 'assets/images/Bell.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Invite Friends',
        'image': 'assets/images/invite.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Joined Groups',
        'image': 'assets/images/group.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Hide Chat History',
        'image': 'assets/images/hide.png',
        'trailing': 'switch'
      },
      {
        "name": 'Security',
        'image': 'assets/images/secure.png',
        'trailing': 'switch'
      },
      {
        "name": 'Term of Service',
        'image': 'assets/images/terms.png',
        'trailing': 'arrow'
      },
      {
        "name": 'About App',
        'image': 'assets/images/about.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Help Center',
        'image': 'assets/images/help.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Logout',
        'image': 'assets/images/logout.png',
        'trailing': 'arrow'
      }
    ];
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
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  itemBuilder: (context, index) {
                    bool switchValue = false;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            items[index]['image'],
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            items[index]['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          _buildTrailingWidget(
                            items[index]['trailing'],
                            switchValue,
                            (newValue) {
                              // Handle switch state changes
                              setState(() {
                                switchValue = newValue;
                              });
                              // Add any additional logic here
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
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

  Widget _buildTrailingWidget(
      String type, bool value, Function(bool)? onChanged) {
    switch (type) {
      case 'arrow':
        return const Icon(Icons.chevron_right);
      case 'switch':
        return Switch(
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstants.AppBarBlue,
        );
      case 'none':
        return const SizedBox.shrink();
      default:
        return const Icon(Icons.chevron_right);
    }
  }
}
