import 'package:chat_app_with_firebase/constants/colors.dart';
import 'package:chat_app_with_firebase/model/user.dart';
import 'package:chat_app_with_firebase/provider/auth.dart';
import 'package:chat_app_with_firebase/views/auth/forgot_pass_screen.dart';
import 'package:chat_app_with_firebase/views/home/home_screen.dart';
import 'package:chat_app_with_firebase/views/auth/sign_up_screen.dart';
import 'package:chat_app_with_firebase/widgets/custom_button.dart';
import 'package:chat_app_with_firebase/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../widgets/textfield_with_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Image(
              image: AssetImage("images/chatlogo.png"),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: s.height * 0.035),
                  TextfieldWithTitle(
                    controller: emailController,
                    title: "Email",
                    hintText: "example@gmail.com",
                  ),
                  SizedBox(height: s.height * 0.025),
                  TextfieldWithTitle(
                    controller: passwordController,
                    title: "Password",
                    hintText: "xxxxxx",
                  ),
                  SizedBox(height: s.height * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          text: "",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "Forgot Password?",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return ForgotPassScreen();
                                      }),
                                    ),
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: s.height * 0.04),
                  Consumer<AuthNotifier>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        title: "Sign in",
                        isLoading: provider.isLoading,
                        callback: () {
                          final UserModel userModel = UserModel(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          final String email = emailController.text;
                          final String password = passwordController.text;
                          if (email.isEmpty || password.isEmpty) {
                            ToastMessage.showToast(
                                "Please fill up the fields", Colors.red);
                          } else {
                            provider.loginUserNotifier(context, userModel);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: s.height * 0.03),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "  Sign up",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return const SignUpScreen();
                                    }), (route) => false),
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
