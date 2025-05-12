import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';

import 'package:real_chat/View/Widgets/responsive_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Widget _buildLanguageDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: false,
        value: selectedLanguage,
        items: languages.map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) async {
          if (newValue != null) {
            setState(() {
              selectedLanguage = newValue;
            });
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('selectedLanguage', newValue);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.right, // ✅ force downward opening
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  String selectedLanguage = 'English'; // default language
  List<String> languages = ['English', 'Spanish', 'Hindi'];
  bool showPopup = false;
  Map<String, bool> switchStates = {
    'darkMode': false,
    'muteNotification': false,
    'hideChatHistory': false,
    'security': false,
  };

  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchStates['darkMode'] = prefs.getBool('darkMode') ?? false;
      switchStates['muteNotification'] =
          prefs.getBool('muteNotification') ?? false;
      switchStates['hideChatHistory'] =
          prefs.getBool('hideChatHistory') ?? false;
      switchStates['security'] = prefs.getBool('security') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "name": 'Language',
        'image': 'assets/images/lang.png',
        'trailing': 'dropdown'
      },
      {
        "name": 'Dark Mode',
        'image': 'assets/images/moon.png',
        'trailing': 'switch',
        'key': 'darkMode'
      },
      {
        "name": 'Mute Notification',
        'image': 'assets/images/mute.png',
        'trailing': 'switch',
        'key': 'muteNotification'
      },
      {
        "name": 'Custom Notification',
        'image': 'assets/images/Bell.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Invite Friends',
        'image': 'assets/images/invite.png',
        'trailing': 'arrow',
        'route': '/InviteFriends'
      },
      {
        "name": 'Joined Groups',
        'image': 'assets/images/group.png',
        'trailing': 'arrow'
      },
      {
        "name": 'Hide Chat History',
        'image': 'assets/images/hide.png',
        'trailing': 'switch',
        'key': 'hideChatHistory'
      },
      {
        "name": 'Security',
        'image': 'assets/images/secure.png',
        'trailing': 'switch',
        'key': 'security',
        'route': '/Security'
      },
      {
        "name": 'Term of Service',
        'image': 'assets/images/terms.png',
        'trailing': 'arrow',
        'route': '/Terms'
      },
      {
        "name": 'About App',
        'image': 'assets/images/about.png',
        'trailing': 'arrow',
        'route': '/About'
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
                    final item = items[index];
                    final isSwitch = item['trailing'] == 'switch';
                    final key = item['key'];
                    final route = item['route'];
                    final switchValue =
                        key != null ? switchStates[key] ?? false : false;

                    return InkWell(
                      onTap: () {
                        if (route != null) {
                          Navigator.pushNamed(context, route).then((_) {
                            _loadSwitchStates();
                          });
                        }
                      },
                      child: Container(
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
                              item['trailing'],
                              switchValue,
                              key,
                              (newValue) {
                                if (key != null) {
                                  setState(() {
                                    switchStates[key] = newValue;
                                  });
                                }
                              },
                              itemName: item['name'],
                            ),
                          ],
                        ),
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
      String type, bool value, String? key, Function(bool)? onChanged,
      {String? itemName}) {
    if (itemName == 'Language') {
      return _buildLanguageDropdown();
    }

    switch (type) {
      case 'arrow':
        return const Icon(Icons.chevron_right);
      case 'switch':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              thumbColor: WidgetStatePropertyAll(Colors.white),
              trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
              inactiveThumbColor: Colors.white,
              value: value,
              onChanged: (newValue) {
                if (key != null) {
                  setState(() {
                    switchStates[key] = newValue;
                  });
                  // Save to SharedPreferences immediately
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool(key, newValue);
                  });
                }
              },
              activeColor: ColorConstants.AppBarBlue,
            ),
            const Icon(Icons.chevron_right),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
