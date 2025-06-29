import 'package:flutter/material.dart';

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
            style: TextStyle(
              fontFamily: 'inter',
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
