import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MessageContainer extends StatelessWidget {
  final bool sender;
  final String messageText;
  const MessageContainer({
    super.key,
    required this.sender,
    required this.messageText,
  });

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Align(
      alignment: sender ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment:
              sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: s.width * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: sender
                    ? Colors.black.withOpacity(0.1)
                    : AppColors.primaryColor,
                borderRadius: sender
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
                messageText,
                style: TextStyle(
                  color: sender ? AppColors.primaryColor : AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: s.height * 0.005),
            Padding(
              padding: sender
                  ? EdgeInsets.only(right: s.width * 0.01)
                  : EdgeInsets.only(left: s.width * 0.01),
              child: const Text(
                "12:30",
                style: TextStyle(
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
}
