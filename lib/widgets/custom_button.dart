import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.title,
    required this.callback,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: s.height * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 15, height: 15, child: CircularProgressIndicator())
              : Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
