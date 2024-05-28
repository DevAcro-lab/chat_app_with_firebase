import 'dart:io';
import 'package:chat_app_with_firebase/model/user.dart';
import 'package:chat_app_with_firebase/views/home/home_screen.dart';
import 'package:chat_app_with_firebase/views/auth/login_screen.dart';
import 'package:chat_app_with_firebase/widgets/toast.dart';
import 'package:chat_app_with_firebase/service/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  bool isLoading = false;

  void toggleLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<String> uploadProfileImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return Future.error('Image upload failed: $e');
    }
  }

  void registerUserNotifier(
      {context, UserModel? userModel, File? imageFile}) async {
    toggleLoading(true);
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadProfileImage(imageFile);
      }
      userModel!.profilePictureUrl = imageUrl;
      var response = await firebaseAuthServices.registration(userModel);
      if (response == "Success") {
        ToastMessage.showToast("User Registered Successfully!", Colors.green);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }), (route) => false);
      } else {
        ToastMessage.showToast(response!, Colors.red);
      }
    } catch (e) {
      ToastMessage.showToast('Registration failed: $e', Colors.red);
    } finally {
      toggleLoading(false);
    }
  }

  void loginUserNotifier(context, UserModel userModel) async {
    toggleLoading(true);
    var response = await firebaseAuthServices.loginUser(userModel);
    if (response is String) {
      if (response == 'Success') {
        ToastMessage.showToast("User Logged In Successfully!", Colors.green);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }), (route) => false);
      } else {
        ToastMessage.showToast(response, Colors.red);
      }
    }
    toggleLoading(false);
  }

  void forgotPasswordNotifier(context, UserModel userModel) async {
    toggleLoading(true);
    var response = await firebaseAuthServices.forgotPassword(userModel);
    if (response == 'Password reset email sent') {
      ToastMessage.showToast(response!, Colors.green);
      Navigator.pop(context);
    } else {
      ToastMessage.showToast(response!, Colors.red);
    }
    toggleLoading(false);
  }
}
