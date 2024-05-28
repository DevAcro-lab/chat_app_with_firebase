import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../constants/colors.dart";
import "../../model/user.dart";
import "../../provider/auth.dart";
import "../../widgets/custom_button.dart";
import "../../widgets/textfield_with_title.dart";
import "../../widgets/toast.dart";

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Image(
              image: AssetImage("images/chatlogo.png"),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: s.height * 0.035),
                  TextfieldWithTitle(
                    controller: emailController,
                    title: "Email",
                    hintText: "example@gmail.com",
                  ),
                  SizedBox(height: s.height * 0.04),
                  Consumer<AuthNotifier>(
                    builder: (context, provider, child) {
                      return CustomButton(
                        title: "Send Mail",
                        isLoading: provider.isLoading,
                        callback: () {
                          final UserModel userModel = UserModel(
                            email: emailController.text,
                          );
                          final String email = emailController.text;
                          if (email.isEmpty) {
                            ToastMessage.showToast(
                                "Please enter an Email", Colors.red);
                          } else {
                            provider.forgotPasswordNotifier(context, userModel);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: s.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
