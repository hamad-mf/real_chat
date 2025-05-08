import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Sign%20Up%20Screen%20Controller/sign_up_controller.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Add%20Personal%20Details/add_personal_details_screen.dart';
import 'package:real_chat/View/SignIn%20Screen/sign_in_screen.dart';
import 'package:real_chat/View/Widgets/custom_textfield.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';
import 'package:real_chat/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _CnfmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.width(30)),
                height: 280,
                color: ColorConstants.ButtonColor1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize:
                                    WidgetStatePropertyAll(Size(112, 53))),
                            onPressed: () {
                              log("navigating to signin screen");
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SignInScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin =
                                        Offset(-1.0, 0.0); // slide from right
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    final tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    final offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                                // (Route<dynamic> route) => false, // this removes all previous routes
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
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                        Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 54,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Enter Your Details",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 32),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Form(
                key: _formKey, // set the form key
                child: Column(
                  children: [
                    CustomTextField(
                      icon: Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      hint: "Enter Your Email",
                      label: "Email",
                      height: 50,
                      width: ResponsiveHelper.width(290),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter you email';
                        }
                        // Basic email format validation
                        if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      icon: Icon(Icons.lock_outline),
                      obscureText: true,
                      controller: _passwordController,
                      hint: "Enter Your Password",
                      label: "Password",
                      height: 50,
                      width: ResponsiveHelper.width(290),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      icon: Icon(Icons.lock),
                      obscureText: true,
                      controller: _CnfmPasswordController,
                      hint: "Re-Enter Your Password",
                      label: "Confirm Password",
                      height: 50,
                      width: ResponsiveHelper.width(290),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "password does'nt match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: context.watch<SignUpController>().isLoading
                  ? CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(290, 50)),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(
                              ColorConstants.ButtonColor1.withOpacity(0.4))),
                      onPressed: () {
                        log("Registering");
                        if (_formKey.currentState!.validate()) {
                          context.read<SignUpController>().onRegsitration(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                        }

                        _emailController.clear();
                        _passwordController.clear();
                        _CnfmPasswordController.clear();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: ResponsiveHelper.width(15),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
