import 'package:chat_app_with_firebase/constants/colors.dart';
import 'package:chat_app_with_firebase/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/auth_services.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () => checkUserAuthentication(),
    );
  }

  Future<void> checkUserAuthentication() async {
    User? currentUser = await firebaseAuthServices.checkCurrentUser();
    if (currentUser != null) {
      // User is already authenticated, navigate to home screen
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }), (route) => false);
    } else {
      // User is not authenticated, navigate to login screen
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("images/chatlogo.png"),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "CHIT - CHAT",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: "",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
