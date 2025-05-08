import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Utils/app_utils.dart';

class SignUpController with ChangeNotifier {
  bool isLoading = false;

  Future<void> onRegsitration(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user?.uid != null) {
        AppUtils.showOnetimeSnackbar(
            bg: Colors.green,
            context: context,
            message: "Registration successful");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "The password provided is too weak",
            bg: Colors.red);
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showOnetimeSnackbar(
            context: context,
            message: "The account already exists for that email.",
            bg: Colors.red);
      } else if (e.code == 'network-request-failed') {
        AppUtils.showOnetimeSnackbar(
            bg: Colors.red,
            context: context,
            message: "please check your network");
      }
    } catch (e) {
      print(e);
      log(e.toString());
      AppUtils.showOnetimeSnackbar(context: context, message: e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
