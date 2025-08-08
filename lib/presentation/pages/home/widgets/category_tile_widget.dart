import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/presentation/pages/home/controllers/home_controller.dart';

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget({super.key, required this.tileIndex});
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            HomeController.instance.changeIsDone(tileIndex);
          },
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: HomeController.instance.getTaskIcon(tileIndex),
              ),
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
            HomeController.instance.tasksNameList[tileIndex],
            style: HomeController.instance.getTaskTextStyle(tileIndex),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            HomeController.instance.removeTaskFromBox(tileIndex);
          },
          icon: Image.asset(AppIcons.delete, width: 24, height: 24),
        ),
      ],
    );
  }
}
