import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatNotifier with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
}
