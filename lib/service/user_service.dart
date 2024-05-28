import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>?> fetchAllUsersExceptCurrentUser() async {
    List<Map<String, dynamic>> userList = [];

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        QuerySnapshot querySnapshot =
            await _firestore.collection('users').get();

        for (var document in querySnapshot.docs) {
          if (document.id != currentUser.uid) {
            Map<String, dynamic> userData =
                document.data() as Map<String, dynamic>;
            userList.add(userData);
          }
        }
        return userList;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("Error fetching users: $error");
      return null;
    }
  }
}
