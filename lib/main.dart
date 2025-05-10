import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_chat/Controller/Profile%20Screen%20Controller/profile_screen_controller.dart';
import 'package:real_chat/Controller/Sign%20In%20Screen%20Controller/sign_in_controller.dart';
import 'package:real_chat/Controller/Sign%20Up%20Screen%20Controller/sign_up_controller.dart';
import 'package:real_chat/View/Splash%20Screen/splash_screen.dart';
import 'package:real_chat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpController(),
        ),
        ChangeNotifierProvider(create: (context) => SignInController(),
        ),
         ChangeNotifierProvider(create: (context) => ProfileScreenController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
