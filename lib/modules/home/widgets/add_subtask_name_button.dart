import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/modules/home/controllers/home_controller.dart';

class AddSubtaskNameButton extends StatelessWidget {
  const AddSubtaskNameButton({super.key, required this.tileIndex});
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: IconButton(
        icon: Image.asset(AppIcons.add, width: 48, height: 48),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              HomeController.instance.cleanTextEditingController();
              return AlertDialog(
                title: const Text("Create New SubTask"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: HomeController.instance.textEditingController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask details",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                actions: <Widget>[
                  FloatingActionButton(
                    backgroundColor: AppColors.appMainColor,
                    onPressed: () {
                      HomeController.instance.addSubTasksNameList(
                        HomeController.instance.textEditingController.text,
                        tileIndex,
                      );
                      HomeController.instance.addSubTaskIsDoneList(tileIndex);
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Icon(Icons.check, color: AppColors.white),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
