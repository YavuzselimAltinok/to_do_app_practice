import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'inter',
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle taskNameTextStyle = TextStyle(
    fontSize: 18,
    letterSpacing: -0.17,
  );

  static const TextStyle taskNameDoneTextStyle = TextStyle(
    fontSize: 18,
    letterSpacing: -0.17,
    decoration: TextDecoration.lineThrough,
    color: AppColors.taskIsDoneColor,
  );

  static const TextStyle emptyStateWidgetTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.grey,
  );
}
