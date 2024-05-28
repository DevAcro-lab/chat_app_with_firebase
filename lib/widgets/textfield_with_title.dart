import 'package:flutter/material.dart';

import 'custom_textfield.dart';

class TextfieldWithTitle extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  const TextfieldWithTitle({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: s.height * 0.005),
        CustomTextField(
          hintText: hintText,
          controller: controller,
        ),
      ],
    );
  }
}
