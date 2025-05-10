import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_chat/Utils/app_utils.dart';
import 'package:real_chat/View/Add%20Personal%20Details/add_personal_details_screen.dart';
import 'package:real_chat/View/Set%20Pin%20Screen/set_pin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController with ChangeNotifier {
  bool isLoading = false;
  File? selectedImage;
  String? uploadedImageUrl;
  bool isUploading = false;

  /// Pick image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  /// Upload image to ImgBB
  Future<String?> uploadImageToImgbb(File imageFile) async {
    const String apiKey =
        'ba920ecb770b8218fc19a1da5636632c'; // Replace this with your actual ImgBB API key

    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());
      final response = await http.post(
        Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
        body: {
          "image": base64Image,
        },
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        return jsonData['data']['url'];
      } else {
        log('ImgBB Upload Failed: ${jsonData['error']['message']}');
      }
    } catch (e) {
      log('Error uploading image: $e');
    }

    return null;
  }

  /// Save prescription to Firestore
  Future<void> savePrescriptionToFirestore({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('profile_details')
          .doc(userId)
          .update({
        'image_url': imageUrl,
      });

      log('Prescription saved to Firestore.');
    } catch (e) {
      log('Error saving prescription: $e');
    }
  }

  /// Upload and Save
  Future<void> uploadAndSavePrescription({
    required String userId,
    required BuildContext context,
  }) async {
    if (selectedImage == null) return;

    isUploading = true;
    notifyListeners();

    try {
      final imageUrl = await uploadImageToImgbb(selectedImage!);
      if (imageUrl != null) {
        await savePrescriptionToFirestore(
          userId: userId,
          imageUrl: imageUrl,
        );
        uploadedImageUrl = imageUrl;
        selectedImage = null;
        notifyListeners();
      }
    } catch (e) {
      log('Upload error: $e');
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void reset() {
    selectedImage = null;
    uploadedImageUrl = null;

    notifyListeners();
  }

Future<bool> isUsernameAvailable(String username) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('profile_details')
      .where('username', isEqualTo: username.toLowerCase())
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (var doc in querySnapshot.docs) {
      final existingUsername = doc['username'];
      print("Checked username conflict: $existingUsername");
    }
  } else {
    print("Username '$username' is available.");
  }

  return querySnapshot.docs.isEmpty;
}
  Future<void> onRegsitration(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //Get the uid of the registered user
      String uid = credential.user!.uid;

      if (credential.user?.uid != null) {
        AppUtils.showOnetimeSnackbar(
            bg: Colors.green,
            context: context,
            message: "Registration successful");

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddPersonalDetailsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // slide from right
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
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

  Future<void> onAddProfile({
    required String username,
    required String gender,
    required DateTime? dob,
    required String name,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        AppUtils.showOnetimeSnackbar(
          context: context,
          message: "No user is logged in.",
          bg: Colors.red,
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      // Check if username is already taken
      final bool usernameAvailable = await isUsernameAvailable(username);
      if (!usernameAvailable) {
        AppUtils.showOnetimeSnackbar(
          context: context,
          message: "Username is already taken. Please choose another one.",
          bg: Colors.red,
        );
        isLoading = false;
        notifyListeners();
        return;
      }

      final String uid = user.uid;
      log("User's uid is : $uid");

      String? imageUrl;
      if (selectedImage != null) {
        imageUrl = await uploadImageToImgbb(selectedImage!);
        log("Image uploaded: $imageUrl");
      }

      // Save both name and image_url to Firestore
      await FirebaseFirestore.instance
          .collection('profile_details')
          .doc(uid)
          .set({
        'name': name,
        'DOB': dob,
        'username': username,
        'gender': gender,
        if (imageUrl != null) 'image_url': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      AppUtils.showOnetimeSnackbar(
        context: context,
        message: "Profile saved successfully!",
        bg: Colors.green,
      );

      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SetPinScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      log("onAddProfile error: $e");
      AppUtils.showOnetimeSnackbar(
        context: context,
        message: "Failed to save profile.",
        bg: Colors.red,
      );
    }

    isLoading = false;
    notifyListeners();
  }
}