import 'package:flutter/material.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          iconSize: 30,
          onPressed: () {
            AuthController.instance.popLoginView(context);
          },
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
              controller: AuthController.instance.emailController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Reset Password",
              onPressed: () async {
                await AuthController.instance.resetPassword(
                  AuthController.instance.emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "An email for password reset has been sent to your email.",
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
                AuthController.instance.popLoginView(context);
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
