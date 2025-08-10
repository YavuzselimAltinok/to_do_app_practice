import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          iconSize: 30,
          onPressed: authController.popLoginView,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text(
              "Forgot Password",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            const Text(
              "Please enter your email address to reset your password.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: authController.emailController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Reset Password",
              onPressed: () async {
                await authController.resetPassword(
                  authController.emailController.text,
                );
                authController.popLoginView();
              },
            ),
            const SizedBox(height: 90),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
