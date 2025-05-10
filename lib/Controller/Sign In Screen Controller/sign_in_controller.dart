
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:real_chat/View/Set%20Pin%20Screen/set_pin_screen.dart';
import 'package:real_chat/View/Widgets/custom_bottom_navbar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInController with ChangeNotifier {
  bool isloading = false;

  onlogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isloading = true;
    notifyListeners();

    try {
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credentials.user?.uid != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CustomBottomNavbarScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }

    isloading = false;
    notifyListeners();
  }


  Future<void> signInWithGoogle(BuildContext context) async {
    isloading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        signInOption: SignInOption.standard,
        scopes: ['email'],
      ).signIn();

      if (googleUser == null) {
        isloading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SetPinScreen()),
        );
      }
    } catch (e) {
      print('Google sign-in error: $e');
    }

    isloading = false;
    notifyListeners();
  }
}
