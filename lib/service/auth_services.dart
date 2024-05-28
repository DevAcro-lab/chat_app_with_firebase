import 'package:chat_app_with_firebase/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? userModel;

  //TODO : REGISTER USER
  Future<String?> registration(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        await userCredential.user!.updateDisplayName(userModel.name!);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userId': userId,
          'name': userModel.name,
          'username': userModel.username,
          'email': userModel.email,
          'profilePictureUrl': userModel.profilePictureUrl,
        });
        return 'Success';
      } else {
        return 'User registration failed';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // TODO : LOGIN USER
  Future<String?> loginUser(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );

      if (userCredential.user != null) {
        return 'Success';
      } else {
        return 'User login failed';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // FORGOT PASSWORD
  Future<String?> forgotPassword(UserModel userModel) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: userModel.email!);
      return 'Password reset email sent';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<User?> checkCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
