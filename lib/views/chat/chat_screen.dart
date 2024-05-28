import 'package:chat_app_with_firebase/constants/colors.dart';
import 'package:chat_app_with_firebase/service/chat_service.dart';
import 'package:chat_app_with_firebase/views/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserId;
  final String receiverName;
  String? userProfileUrl;
  ChatScreen(
      {super.key,
      required this.receiverUserId,
      required this.receiverName,
      this.userProfileUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    print("CLICKED: ");
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.receiverUserId, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.whiteColor,
            ),
          ),
          centerTitle: false,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfileScreen(receiverId: widget.receiverUserId);
              }));
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.userProfileUrl == null
                      ? AssetImage('images/user.png')
                      : NetworkImage(widget.userProfileUrl!)
                          as ImageProvider<Object>,
                ),
                SizedBox(width: s.width * 0.02),
                Text(
                  widget.receiverName,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: buildMessageList()),
            buildMessageInput(),
          ],
        ));
  }

  Widget buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessage(
            widget.receiverUserId, firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR ${snapshot.error}");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Say HI',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map(
                    (e) => buildMessageItem(e),
                  )
                  .toList(),
            );
          }
        });
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp timestamp = data["timestamp"];
    DateTime dateTime = timestamp.toDate();

    String formattedTime = DateFormat.jm().format(dateTime);
    final s = MediaQuery.of(context).size;
    bool currentUser = (data["senderId"] != firebaseAuth.currentUser!.uid);
    return Align(
      alignment: currentUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment:
              currentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: s.width * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: currentUser
                    ? Colors.grey.withOpacity(0.2)
                    : AppColors.primaryColor,
                borderRadius: currentUser
                    ? const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
              child: Text(
                data["message"],
                style: TextStyle(
                  color: currentUser ? Colors.black : AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: s.height * 0.003),
            Padding(
              padding: currentUser
                  ? EdgeInsets.only(right: s.width * 0.01)
                  : EdgeInsets.only(left: s.width * 0.01),
              child: Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    final s = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: s.width * 0.03, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: s.width * 0.8,
            height: s.height * 0.055,
            child: TextField(
              controller: messageController,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Type here",
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.only(bottom: 10, left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send_outlined,
                  size: 20,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
