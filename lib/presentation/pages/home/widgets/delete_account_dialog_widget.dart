import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/custom_text_field_widget.dart';

class DeleteAccountDialogWidget extends StatefulWidget {
  const DeleteAccountDialogWidget({super.key});

  @override
  State<DeleteAccountDialogWidget> createState() =>
      _DeleteAccountDialogWidgetState();
}

class _DeleteAccountDialogWidgetState extends State<DeleteAccountDialogWidget> {
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
            controller: AuthController.instance.passwordController,
          ),
          if (AuthController.instance.deleteAccountErrorMessage.isNotEmpty)
            SizedBox(
              width: 400,
              height: 20,
              child: AutoSizeText(
                AuthController.instance.deleteAccountErrorMessage,
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
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () async {
            AuthController.instance.clearErrorMessages();
            await AuthController.instance.deleteAccount(
              AuthController.instance.passwordController.text,
            );
            if (AuthController.instance.deleteAccountErrorMessage.isEmpty) {
              Navigator.of(context).pop();
              await AuthController.instance.logout(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted successfully.')),
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
