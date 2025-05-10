import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_chat/Utils/app_utils.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getProfileDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('profile_details')
        .doc(uid)
        .get();
  }

  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: Stack(
        children: [
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
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getProfileDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!.exists) {
                      return const Center(
                          child: Text("Failed to load profile details."));
                    }

                    final data = snapshot.data!.data();
                    final imageUrl = data?['image_url'];
                    final name = data?['name'] ?? 'N/A';
                    final username = data?['username'] ?? 'N/A';
                    final gender = data?['gender'] ?? 'N/A';
                    final dobTimestamp = data?['DOB'];
                    final dob = dobTimestamp != null
                        ? (dobTimestamp as Timestamp).toDate()
                        : null;
                    final email =
                        FirebaseAuth.instance.currentUser?.email ?? 'N/A';

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 35),
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.amber,
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl == null
                                      ? const Icon(Icons.person, size: 70)
                                      : null,
                                ),
                                Positioned(
                                  right: 1,
                                  top: 0,
                                  child: InkWell(
                                    child: CircleAvatar(
                                      backgroundColor: ColorConstants.Textblue,
                                      radius: 18,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35),
                            Text(
                              name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Username : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorConstants.GreyText),
                                        ),
                                        Text(
                                          "$username",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: username));

                                              AppUtils.showOnetimeSnackbar(
                                                  context: context,
                                                  message:
                                                      "Username copied to clipboard",
                                                  bg: ColorConstants
                                                      .AppBarBlue);
                                            },
                                            child: Icon(Icons.copy))
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          "Gender : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorConstants.GreyText),
                                        ),
                                        Text(
                                          "$gender",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: gender));

                                              AppUtils.showOnetimeSnackbar(
                                                  context: context,
                                                  message:
                                                      "Gender copied to clipboard",
                                                  bg: ColorConstants
                                                      .AppBarBlue);
                                            },
                                            child: Icon(Icons.copy))
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          "Birthday : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorConstants.GreyText),
                                        ),
                                        Text(
                                          "${dob != null ? '${dob.day}-${dob.month}-${dob.year}' : 'N/A'}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        Icon(Icons.copy)
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          "Email : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorConstants.GreyText),
                                        ),
                                        Text(
                                          "$email",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: gender));

                                              AppUtils.showOnetimeSnackbar(
                                                  context: context,
                                                  message:
                                                      "Email copied to clipboard",
                                                  bg: ColorConstants
                                                      .AppBarBlue);
                                            },
                                            child: Icon(Icons.copy))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _Button(
                                        "Edit Profile",
                                        ColorConstants.EditButton,
                                        Icons.edit_outlined),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    _Button(
                                        "Logout",
                                        Colors.orange.withOpacity(0.2),
                                        Icons.exit_to_app_outlined),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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

  ElevatedButton _Button(String name, Color? bgcolor, IconData icon) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            backgroundColor: WidgetStatePropertyAll(bgcolor),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56))),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: ResponsiveHelper.width(16),
            ),
            Text(
              name,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
