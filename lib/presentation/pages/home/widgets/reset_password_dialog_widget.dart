import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_button_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class ResetPasswordDialogWidget extends StatelessWidget {
  const ResetPasswordDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
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
            controller: authController.passwordController,
          ),
          const SizedBox(height: 20),
          const Text('Enter your new password:'),
          const SizedBox(height: 4),
          CustomTextField(
            hint: "Enter New Password",
            label: "New Password",
            controller: authController.resetPasswordController,
          ),
          Obx(
            () => authController.resetPasswordErrorMessage.value.isNotEmpty
                ? SizedBox(
                    width: 300,
                    height: 20,
                    child: AutoSizeText(
                      authController.resetPasswordError,
                      style: const TextStyle(color: Colors.red),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : const SizedBox.shrink(),
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
            authController.clearErrorMessages();
            await authController.changePassword(
              authController.passwordController.text,
              authController.resetPasswordController.text,
            );
            if (authController.resetPasswordErrorMessage.isEmpty) {
              Get.back();
              Get.snackbar(
                'Success',
                'Password changed successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          label: 'Reset Password',
        ),
      ],
    );
  }
}
