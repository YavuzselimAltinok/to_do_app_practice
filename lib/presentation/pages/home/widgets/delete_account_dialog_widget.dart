import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class DeleteAccountDialogWidget extends StatelessWidget {
  const DeleteAccountDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return AlertDialog(
      title: const Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'This action cannot be undone. Please enter your password to confirm:',
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: "Enter Password",
            label: "Password",
            controller: authController.passwordController,
          ),
          Obx(
            () => authController.deleteAccountErrorMessage.value.isNotEmpty
                ? SizedBox(
                    width: 400,
                    height: 20,
                    child: AutoSizeText(
                      authController.deleteAccountError,
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
          onPressed: Get.back,
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () async {
            authController.clearErrorMessages();
            await authController.deleteAccount(
              authController.passwordController.text,
            );
            if (authController.deleteAccountErrorMessage.isEmpty) {
              Get.back();
              await authController.logout();
              Get.snackbar(
                'Success',
                'Account deleted successfully.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete Account'),
        ),
      ],
    );
  }
}
