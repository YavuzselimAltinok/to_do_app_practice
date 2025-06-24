import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  const Task({
    super.key,
    required this.taskName,
    required this.taskCondition,
    required this.onTapDoneButton,
    required this.rectangleColor,
    required this.onTapRevomeTaskButton,
  });

  final String taskName;
  final bool taskCondition;
  final VoidCallback onTapDoneButton;
  final VoidCallback onTapRevomeTaskButton;
  final Color rectangleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: onTapDoneButton,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: rectangleColor,
                  borderRadius: BorderRadius.circular(6),
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
                taskName,
                style: const TextStyle(fontSize: 18, letterSpacing: -0.17),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: onTapRevomeTaskButton,
            ),
          ],
        ),
      ),
    );
  }
}
