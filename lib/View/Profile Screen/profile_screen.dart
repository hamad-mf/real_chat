import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Profile%20Screen%20Controller/profile_screen_controller.dart';
import 'package:real_chat/Utils/app_utils.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/On%20Boarding%20Screen/on_boarding_screen.dart';
import 'package:real_chat/View/Widgets/custom_textfield.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    final ProfileController = context.watch<ProfileScreenController>();
    void showEditProfileBottomSheet({
      required String name,
      required String username,
      required String gender,
      required DateTime? dob,
      required String email,
    }) {
      TextEditingController nameController = TextEditingController(text: name);
      TextEditingController usernameController =
          TextEditingController(text: username);
      TextEditingController emailController =
          TextEditingController(text: email);
      TextEditingController dobController = TextEditingController(
          text: dob != null ? "${dob.day}/${dob.month}/${dob.year}" : '');
      String selectedGender = gender;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Edit Profile",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    CustomTextField(
                        label: "Name",
                        controller: nameController,
                        height: 30,
                        width: ResponsiveHelper.width(double.infinity)),
                    const SizedBox(height: 12),
                    CustomTextField(
                        label: "Username",
                        controller: usernameController,
                        height: 30,
                        width: ResponsiveHelper.width(double.infinity)),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: const InputDecoration(labelText: 'Gender'),
                        items: [
                          'Male',
                          'Female',
                        ]
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedGender = value;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      height: 30,
                      width: double.infinity,
                      controller: dobController,
                      isReadonly: true,
                      label: 'Birthday',
                      OnTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dob ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dobController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      height: 30,
                      width: double.infinity,
                      controller: emailController,
                      label: "Email",
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                DateTime? parsedDob;
                                if (dobController.text.isNotEmpty) {
                                  final parts = dobController.text.split('/');
                                  if (parts.length == 3) {
                                    parsedDob = DateTime(
                                      int.parse(parts[2]),
                                      int.parse(parts[1]),
                                      int.parse(parts[0]),
                                    );
                                  }
                                }

                                ProfileController.onEditProfile(
                                  EditedUsername:
                                      usernameController.text.trim(),
                                  EditedGender: selectedGender,
                                  EditedDOb: parsedDob,
                                  EditedName: nameController.text.trim(),
                                  context: context,
                                );

                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

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
                  child: // Replace your FutureBuilder with this StreamBuilder
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('profile_details')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
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
                                            Clipboard.setData(
                                                ClipboardData(text: username));

                                            AppUtils.showOnetimeSnackbar(
                                                context: context,
                                                message:
                                                    "Username copied to clipboard",
                                                bg: ColorConstants.AppBarBlue);
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
                                                bg: ColorConstants.AppBarBlue);
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
                                                bg: ColorConstants.AppBarBlue);
                                          },
                                          child: Icon(Icons.copy))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _Button(() {
                                    showEditProfileBottomSheet(
                                      name: name,
                                      username: username,
                                      gender: gender,
                                      dob: dob,
                                      email: email,
                                    );
                                  }, "Edit Profile", ColorConstants.EditButton,
                                      Icons.edit_outlined),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _Button(() async {
                                    await FirebaseAuth.instance.signOut();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool('isLoggedIn',
                                        false); // Set isLoggedIn to false
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => OnBoardingScreen()),
                                    );
                                  }, "Logout", Colors.orange.withOpacity(0.2),
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
              )),
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

  ElevatedButton _Button(
      void Function()? ontap, String name, Color? bgcolor, IconData icon) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            backgroundColor: WidgetStatePropertyAll(bgcolor),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56))),
        onPressed: ontap,
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
