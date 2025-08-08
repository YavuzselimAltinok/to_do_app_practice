import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    AuthController.instance.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    AuthController.instance.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              controller: AuthController.instance.emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: AuthController.instance.passwordController,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: AutoSizeText(
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    AuthController.instance.loginErrorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    AuthController.instance.popForgotPasswordView(context);
                  },
                  child: const Text("Forgot your password?"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Login",
              onPressed: () async {
                AuthController.instance.clearErrorMessages();
                await AuthController.instance.loginUser(
                  AuthController.instance.emailController.text,
                  AuthController.instance.passwordController.text,
                );
                if (AuthController.instance.loginErrorMessage.isEmpty) {
                  AuthController.instance.popHomeView(context);
                }
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? "),
                InkWell(
                  onTap: () {
                    AuthController.instance.popSignUpView(context);
                  },
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
