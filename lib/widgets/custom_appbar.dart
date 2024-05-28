import 'package:chat_app_with_firebase/service/auth_services.dart';
import 'package:chat_app_with_firebase/views/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomAppBar extends StatelessWidget {
  final bool showLeading;
  const CustomAppBar({
    super.key,
    required this.showLeading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      leading: showLeading
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.whiteColor,
              ))
          : null,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuthServices().signOut().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), (route) => false);
            });
          },
          icon: Icon(
            Icons.logout_outlined,
            color: AppColors.whiteColor,
          ),
        ),
      ],
      title: const Image(
        height: 50,
        image: AssetImage("images/chatlogo.png"),
      ),
    );
  }
}
