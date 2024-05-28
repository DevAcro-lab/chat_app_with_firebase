import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String message;
  final String senderEmail;
  final String receiverId;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "message": message,
      "senderEmail": senderEmail,
      "receiverId": receiverId,
      "timestamp": timestamp,
    };
  }
}
