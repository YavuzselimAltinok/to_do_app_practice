import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/presentation/pages/home/controllers/home_controller.dart';

class AddSubtaskNameButton extends StatelessWidget {
  const AddSubtaskNameButton({super.key, required this.tileIndex});
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Positioned(
      bottom: 16,
      right: 16,
      child: IconButton(
        icon: Image.asset(AppIcons.add, width: 48, height: 48),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              homeController.cleanTextEditingController();
              return AlertDialog(
                title: const Text("Create New SubTask"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: homeController.textEditingController,
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
                      homeController.addSubTask(
                        homeController.textEditingController.text,
                        tileIndex,
                      );
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Icon(Icons.check, color: AppColors.white),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Subtask',
      ),
    );
  }
}
