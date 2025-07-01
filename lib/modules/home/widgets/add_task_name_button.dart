import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/modules/home/controllers/home_controller.dart';

class AddTaskNameButton extends StatelessWidget {
  const AddTaskNameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HomeController.instance.cleanTileEditingController();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Create New Task'),
              content: TextField(
                controller: HomeController.instance.tileEditingController,
                decoration: const InputDecoration(hintText: 'Enter Task Name'),
              ),
              actions: <Widget>[
                FloatingActionButton(
                  backgroundColor: AppColors.appMainColor,
                  onPressed: () {
                    if (HomeController
                        .instance
                        .tileEditingController
                        .text
                        .isNotEmpty) {
                      HomeController.instance.addTasksNameToList(
                        HomeController.instance.tileEditingController.text,
                      );
                      HomeController.instance.addTaskIsDoneList();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(Icons.check, color: AppColors.white),
                ),
              ],
            );
          },
        );
      },
      icon: Image.asset(AppIcons.add, width: 48, height: 48),
    );
  }
}
