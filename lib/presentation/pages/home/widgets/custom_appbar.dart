import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';
import 'package:state_management_practice/presentation/pages/auth/controllers/auth_controller.dart';
import 'package:state_management_practice/presentation/pages/auth/widgets/reset_password_dialog_widget.dart';
import 'package:state_management_practice/presentation/pages/home/widgets/delete_account_dialog_widget.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ' Tasked',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.appBarTitle,
              ),
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'reset_password':
                  _showResetPasswordDialog(context);
                  break;
                case 'delete_account':
                  _showDeleteAccountDialog(context);
                  break;
                case 'logout':
                  AuthController.instance.logout(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'reset_password',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.lock_reset, size: 20),
                    SizedBox(width: 12),
                    Text('Reset Password'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete_account',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete_forever, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Account', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.settings, size: 30),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    AuthController.instance.clearControllers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ResetPasswordDialogWidget();
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    AuthController.instance.clearControllers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAccountDialogWidget();
      },
    );
  }
}
