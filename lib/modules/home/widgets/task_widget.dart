import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  const Task({
    super.key,
    required this.subTaskName,
    required this.subTaskCondition,
    required this.onTapDoneButton,
    required this.subtaskIcon,
    required this.onTapRevomeSubTaskButton,
    required this.subTaskTextStyle,
  });

  final String subTaskName;
  final bool subTaskCondition;
  final VoidCallback onTapDoneButton;
  final VoidCallback onTapRevomeSubTaskButton;
  final AssetImage subtaskIcon;
  final TextStyle subTaskTextStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 25),
            GestureDetector(
              onTap: onTapDoneButton,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  image: DecorationImage(image: subtaskIcon),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 250,
              child: AutoSizeText(
                minFontSize: 14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                subTaskName,
                style: subTaskTextStyle,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/delete_icon.png',
                width: 24,
                height: 24,
              ),
              onPressed: onTapRevomeSubTaskButton,
            ),
          ],
        ),
      ),
    );
  }
}
