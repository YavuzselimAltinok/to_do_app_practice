import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/features/auth/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/custom_text_field_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text(
              "Login",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: authController.emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: authController.passwordController,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(
                  () => SizedBox(
                    width: 250,
                    child: AutoSizeText(
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      authController.loginError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: authController.popForgotPasswordView,
                  child: const Text("Forgot your password?"),
                ),
              ],
            ),

            const SizedBox(height: 30),
            CustomButton(label: "Login", onPressed: authController.loginUser),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? "),
                InkWell(
                  onTap: authController.popSignUpView,
                  child: const Text(
                    "Signup",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
