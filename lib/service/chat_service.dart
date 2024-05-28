import 'package:chat_app_with_firebase/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firestoreAuth = FirebaseAuth.instance;

  Future<void> sendMessage(
    String receiverId,
    String message,
  ) async {
    final String currentUserId = _firestoreAuth.currentUser!.uid;
    final String currentUserEmail =
        _firestoreAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        message: message,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toJson());
  }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChatRooms() {
    final String currentUserId = _firestoreAuth.currentUser!.uid;
    final List<String> chatRoomIds = _getChatRoomIdsForUser(currentUserId);

    if (chatRoomIds.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection("chat_rooms")
        .where(FieldPath.documentId, whereIn: chatRoomIds)
        .snapshots();
  }

  List<String> _getChatRoomIdsForUser(String userId) {
    final List<String> ids = userId.split('_');
    final List<String> chatRoomIds = [];

    for (String id in ids) {
      if (id != userId) {
        String chatRoomId =
            userId.compareTo(id) < 0 ? "${userId}_$id" : '${id}_$userId';
        chatRoomIds.add(chatRoomId);
      }
    }

    return chatRoomIds;
  }
}
