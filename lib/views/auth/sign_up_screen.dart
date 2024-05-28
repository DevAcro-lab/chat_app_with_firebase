import 'dart:io';

import 'package:chat_app_with_firebase/provider/auth.dart';
import 'package:chat_app_with_firebase/views/auth/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../model/user.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/textfield_with_title.dart';
import '../../widgets/toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    // Request permission
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        setState(() {
          _pickedImage = File(pickedImageFile.path);
        });
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text(
              'Please enable photo permissions in settings to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Image(
              image: AssetImage("images/chatlogo.png"),
            ),
          ),
          Expanded(
            flex: 9,
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
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : AssetImage('images/user.png')
                                    as ImageProvider,
                          ),
                          Positioned(
                            top: 10,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: s.height * 0.035),
                  TextfieldWithTitle(
                    controller: nameController,
                    title: "Name",
                    hintText: "John Cena",
                  ),
                  SizedBox(height: s.height * 0.025),
                  TextfieldWithTitle(
                    controller: usernameController,
                    title: "Username",
                    hintText: "@username",
                  ),
                  SizedBox(height: s.height * 0.025),
                  TextfieldWithTitle(
                    controller: emailController,
                    title: "Email",
                    hintText: "example@gmail.com",
                  ),
                  SizedBox(height: s.height * 0.025),
                  TextfieldWithTitle(
                    controller: passwordController,
                    title: "Password",
                    hintText: "xxxxx",
                  ),
                  SizedBox(height: s.height * 0.04),
                  Consumer<AuthNotifier>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        title: "Sign up",
                        isLoading: provider.isLoading,
                        callback: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          final username = usernameController.text;
                          final name = nameController.text;
                          final UserModel userModel = UserModel(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            username: usernameController.text,
                          );
                          if (email.isEmpty ||
                              password.isEmpty ||
                              username.isEmpty ||
                              name.isEmpty ||
                              _pickedImage == null) {
                            ToastMessage.showToast(
                                "Please fill up the fields", Colors.red);
                          } else {
                            provider.registerUserNotifier(
                                context: context,
                                userModel: userModel,
                                imageFile: _pickedImage);
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
                          text: "Already have an account?",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: "  Log In",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return const LoginScreen();
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
