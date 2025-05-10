import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/Utils/app_utils.dart';

class ProfileScreenController with ChangeNotifier {
  bool isloading = false;

Future<bool> isUsernameAvailable(String username) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('profile_details')
      .where('username', isEqualTo: username.toLowerCase())
      .get();

  for (var doc in querySnapshot.docs) {
    if (doc.id != currentUser?.uid) {
      print("Checked username conflict: ${doc['username']}");
      return false; // Another user has this username
    }
  }

  print("Username '$username' is available.");
  return true;
}

  Future<void> onEditProfile(
      {required String EditedUsername,
      required String EditedGender,
      required DateTime? EditedDOb,
      required String EditedName,
      required BuildContext context}) async {
    isloading = true;
    notifyListeners();
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        AppUtils.showOnetimeSnackbar(
            context: context, message: "no user is logged in ", bg: Colors.red);
        isloading = false;
        notifyListeners();
        return;
      }

      //check if username is already taken
      final bool usernameAvailable = await isUsernameAvailable(EditedUsername);
      if (!usernameAvailable) {
        AppUtils.showOnetimeSnackbar(
            context: context,
            bg: Colors.red,
            message: "Username is already taken. Please choose another one.");
        isloading = false;
        notifyListeners();
        return;
      }
      final String uid = user.uid;
      //save  the updated data to firestore
      await FirebaseFirestore.instance
          .collection('profile_details')
          .doc(uid)
          .update({
        'name': EditedName,
        'DOB': EditedDOb,
        'username': EditedUsername,
        'gender': EditedGender
      });
           AppUtils.showOnetimeSnackbar(
        context: context,
        message: "Profile Updated successfully!",
        bg: Colors.green,
      );
    } catch (e) {
      log("Edit Profile error: $e");
      AppUtils.showOnetimeSnackbar(
        context: context,
        message: "Failed to save profile.",
        bg: Colors.red,
      );
    }
    
    isloading = false;
    notifyListeners();
  }
}
