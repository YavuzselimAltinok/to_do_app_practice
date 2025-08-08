import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class ResetPasswordDialogWidget extends StatefulWidget {
  const ResetPasswordDialogWidget({super.key});

  @override
  State<ResetPasswordDialogWidget> createState() =>
      _ResetPasswordDialogWidgetState();
}

class _ResetPasswordDialogWidgetState extends State<ResetPasswordDialogWidget> {
  @override
  void initState() {
    super.initState();
    AuthController.instance.clearControllers();
    AuthController.instance.clearErrorMessages();
    AuthController.instance.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    AuthController.instance.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(width: 300, height: 20),
          const Text('Enter your current password:'),
          const SizedBox(height: 4),
          CustomTextField(
            hint: "Enter Current Password",
            label: "Current Password",
            controller: AuthController.instance.passwordController,
          ),
          const SizedBox(height: 20),
          const Text('Enter your new password:'),
          const SizedBox(height: 4),
          CustomTextField(
            hint: "Enter New Password",
            label: "New Password",
            controller: AuthController.instance.resetPasswordController,
          ),
          if (AuthController.instance.passwordController.text.isNotEmpty ||
              ((AuthController
                          .instance
                          .resetPasswordController
                          .text
                          .isNotEmpty &&
                      AuthController
                          .instance
                          .passwordController
                          .text
                          .isNotEmpty) &&
                  (AuthController.instance.resetPasswordController.text ==
                      AuthController.instance.passwordController.text)))
            SizedBox(
              width: 300,
              height: 20,
              child: AutoSizeText(
                AuthController.instance.resetPasswordErrorMessage.isNotEmpty
                    ? AuthController.instance.resetPasswordErrorMessage
                    : "New password must be different from current password.",
                style: const TextStyle(color: Colors.red),
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.appMainColor),
          ),
        ),
        CustomButton(
          onPressed: () async {
            AuthController.instance.clearErrorMessages();
            await AuthController.instance.resetPasswordFromCurrentPassword(
              AuthController.instance.passwordController.text,
              AuthController.instance.resetPasswordController.text,
            );
            if (AuthController.instance.resetPasswordErrorMessage.isEmpty &&
                (AuthController.instance.passwordController.text !=
                    AuthController.instance.resetPasswordController.text)) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset successfully.')),
              );
            }
          },
          label: 'Reset Password',
        ),
      ],
    );
  }
}
