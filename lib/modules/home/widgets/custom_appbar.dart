import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 80,
      child: Padding(
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
    );
  }
}
