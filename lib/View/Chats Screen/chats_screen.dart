import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Chat%20Screen/chat_screen.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getAllUsers() {
    return FirebaseFirestore.instance
        .collection('profile_details')
        .where(FieldPath.documentId, isNotEqualTo: currentUserUid)
        .snapshots();
  }

  bool showPopup = false;

  @override
  void initState() {
    log("Current User UID: $currentUserUid");
    super.initState();
  }

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
                child: StreamBuilder<QuerySnapshot>(
                  stream: getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      log("Error: ${snapshot.error}");
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No users found'));
                    }

                    final users = snapshot.data!.docs;
                    log("Users count: ${users.length}"); // Debug print

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userData = user.data() as Map<String, dynamic>;
                        log("User data: ${user.data()}"); // Debug print
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverUsername:
                                        userData['username'] ?? 'no username',
                                    receiverId: user.id,
                                    receiverName: userData['name'] ?? 'no name',
                                    receiverImage: userData['image_url'] ?? '',
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 6,
                                //     offset: Offset(0, 5),
                                //   ),
                                // ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 21,
                                    backgroundImage:
                                        NetworkImage(user['image_url']),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "10:25",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants
                                                      .msgDateTime),
                                            )
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "last message",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorConstants
                                                        .lastMessage),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .msgCountContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Text(
                                                  "5",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
}
