import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Sign%20Up%20Screen%20Controller/sign_up_controller.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/SignIn%20Screen/sign_in_screen.dart';
import 'package:real_chat/View/Widgets/custom_textfield.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class AddPersonalDetailsScreen extends StatefulWidget {
  const AddPersonalDetailsScreen({super.key});

  @override
  State<AddPersonalDetailsScreen> createState() => _AddPersonalDetailsScreenState();
}

class _AddPersonalDetailsScreenState extends State<AddPersonalDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signUpController = context.watch<SignUpController>();
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.width(30)),
                    height: 290,
                    color: ColorConstants.ButtonColor1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(Size(112, 53)),
                              ),
                              onPressed: () {
                                log("navigating to signin screen");
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        SignInScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(-1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      final offsetAnimation = animation.drive(tween);

                                      return SlideTransition(position: offsetAnimation, child: child);
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      color: ColorConstants.Textbluelight,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 54),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 110,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.amber,
                        backgroundImage: signUpController.selectedImage != null
                            ? FileImage(signUpController.selectedImage!)
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      ),
                      Positioned(
                        right: 1,
                        top: 0,
                        child: InkWell(
                          onTap: () => signUpController.pickImage(),
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
                )
              ],
            ),
            const SizedBox(height: 80),
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hint: "Enter Your Name",
                      label: "Name",
                      height: 50,
                      width: ResponsiveHelper.width(290),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: signUpController.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(CircleBorder()),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(
                            ColorConstants.ButtonColor1.withOpacity(0.4)),
                      ),
                      onPressed: () {
                        log("navigating to pin setting screen");
                        if (_formKey.currentState!.validate()) {
                          signUpController.onAddProfile(
                            name: _nameController.text,
                            context: context,
                          );
                          _nameController.clear();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.arrow_forward, size: 30),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
