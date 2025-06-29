import 'package:flutter/material.dart';
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
        icon: Image.asset('assets/icons/add_icon.png', width: 48, height: 48),
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
                    backgroundColor: const Color.fromARGB(255, 54, 34, 82),
                    onPressed: () {
                      HomeController.instance.addSubTasksNameList(
                        HomeController.instance.textEditingController.text,
                        tileIndex,
                      );
                      HomeController.instance.addSubTaskIsDoneList(tileIndex);
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Icon(Icons.check, color: Colors.white),
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
