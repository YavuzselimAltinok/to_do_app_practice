import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/controllers/home_controller.dart';

class AddTaskNameButton extends StatelessWidget {
  const AddTaskNameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return IconButton(
      onPressed: () {
        homeController.cleanTileEditingController();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Create New Task'),
              content: TextField(
                controller: homeController.tileEditingController,
                decoration: const InputDecoration(hintText: 'Enter Task Name'),
              ),
              actions: <Widget>[
                FloatingActionButton(
                  backgroundColor: AppColors.appMainColor,
                  onPressed: homeController.createTask,
                  child: const Icon(Icons.check, color: AppColors.white),
                ),
              ],
            );
          },
        );
      },
      icon: Image.asset(AppIcons.add, width: 48, height: 48),
      tooltip: 'Add Task',
    );
  }
}
