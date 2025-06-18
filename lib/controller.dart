import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  List<String> tasksNameList = [];
  List<bool> tasksIsDoneList = [];
  Controller._();
  static final Controller instance = Controller._();

  void addTasksNameToList(String taskName) {
    tasksNameList.add(taskName);
  }

  void addTaskIsDoneList() {
    tasksIsDoneList.add(false);
  }

  void changeIsDone(int index) {
    tasksIsDoneList[index] = !tasksIsDoneList[index];
  }

  Color getColor(int index) =>
      tasksIsDoneList[index] ? Colors.green : Colors.black;
  // if (tasksIsDoneList[index]) {
  //   return Colors.green;
  // } else {
  //   return Colors.black;
  // }

  TextEditingController textEditingController = TextEditingController();
}
