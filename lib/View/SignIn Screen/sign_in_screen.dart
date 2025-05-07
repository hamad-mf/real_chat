import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:real_chat/Utils/color_constants.dart';
import 'package:real_chat/View/Widgets/custom_textfield.dart';
import 'package:real_chat/View/Widgets/responsive_helper.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isChecked = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ResponsiveHelper.width(30)),
              height: 250,
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
                      Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              minimumSize:
                                  WidgetStatePropertyAll(Size(112, 53))),
                          onPressed: () {},
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: ColorConstants.Textbluelight,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 54,
                  ),
                  Text(
                    "Enter Your Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 32),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Column(
              children: [
                CustomTextField(
                    controller: _emailController,
                    hint: "Enter Your Email",
                    label: "Email",
                    height: 50,
                    width: ResponsiveHelper.width(290)),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: _passwordController,
                    hint: "Enter Your Password",
                    label: "Password",
                    height: 50,
                    width: ResponsiveHelper.width(290)),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.width(35)),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2, // Adjust size
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                          activeColor: Colors.green, // Color when checked
                          checkColor: Colors.white, // Checkmark color
                          fillColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.blue; // Selected state color
                            }
                            return Colors.transparent; // Unselected state color
                          }),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                          side: BorderSide(
                            color: Colors.blueAccent,
                            width: 1,
                          ),
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(290, 50)),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(
                        ColorConstants.ButtonColor1.withOpacity(0.4))),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Login",
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  "OR",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border:
                        Border.all(color: const Color(0xFFBDBDBD), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/GOOGLE_LOGO.png', width: 20),
                      const SizedBox(width: 10),
                      const Text('Sign up with Google',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
