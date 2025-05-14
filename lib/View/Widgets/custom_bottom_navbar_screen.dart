import 'package:flutter/material.dart';
import 'package:real_chat/View/Chats%20Screen/chats_screen.dart';
import 'package:real_chat/View/Group%20Screen/group_screen.dart';
import 'package:real_chat/View/More%20Screen/more_screen.dart';
import 'package:real_chat/View/Profile%20Screen/profile_screen.dart';

class CustomBottomNavbarScreen extends StatefulWidget {
  const CustomBottomNavbarScreen({super.key});

  @override
  State<CustomBottomNavbarScreen> createState() =>
      _CustomBottomNavbarScreenState();
}

class _CustomBottomNavbarScreenState extends State<CustomBottomNavbarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ChatsScreen(),
    GroupScreen(),
    ProfileScreen(),
    MoreScreen()
  ];

  final List<Map<String, dynamic>> _navItems = [
    {
      'selectedIcon': 'assets/images/icons/chats_selected.png',
      'unselectedIcon': 'assets/images/icons/chats_unselected.png',
      'label': 'Chats',
    },
    {
      'selectedIcon': 'assets/images/icons/groups_selected.png',
      'unselectedIcon': 'assets/images/icons/groups_unselected.png',
      'label': 'Groups',
    },
    {
      'selectedIcon': 'assets/images/icons/profile_selected.png',
      'unselectedIcon': 'assets/images/icons/profile_unselected.png',
      'label': 'Profile',
    },
    {
      'selectedIcon': 'assets/images/icons/more_selected.png',
      'unselectedIcon': 'assets/images/icons/more_unselected.png',
      'label': 'More',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            bool isSelected = _currentIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _currentIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: isSelected
                    ? BoxDecoration(
                        color: const Color(0xFF097BD7),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isSelected
                          ? _navItems[index]['selectedIcon']
                          : _navItems[index]['unselectedIcon'],
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _navItems[index]['label'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
