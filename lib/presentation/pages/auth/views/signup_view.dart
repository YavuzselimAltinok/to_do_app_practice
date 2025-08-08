import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
              "SignUp",
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
            SizedBox(
              width: 500,
              child: AutoSizeText(
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                AuthController.instance.signUpErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "SignUp",
              onPressed: () async {
                AuthController.instance.clearErrorMessages();
                await AuthController.instance.signUpUser(
                  AuthController.instance.emailController.text,
                  AuthController.instance.passwordController.text,
                );
                if (AuthController.instance.signUpErrorMessage.isEmpty) {
                  AuthController.instance.popHomeView(context);
                }
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already have an account? "),
                InkWell(
                  onTap: () {
                    AuthController.instance.popLoginView(context);
                  },
                  child: const Text(
                    "Login",
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
