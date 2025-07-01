import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No categories yet.\nTap the + button to create your first category!',
        textAlign: TextAlign.center,
        style: AppTextStyles.emptyStateWidgetTextStyle,
      ),
    );
  }
}
