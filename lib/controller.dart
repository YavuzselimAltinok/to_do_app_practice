import 'package:flutter/material.dart';
import 'package:state_management_practice/hive_service.dart';

class Controller {
  Controller._();
  late Map<String, List<dynamic>> tasks;
  static final Controller instance = Controller._();

  void fetchTasks() {
    tasks = LocalDatabaseService.instance.getTasks();
  }

  void addTasksNameToList(String taskName) {
    tasks["tasksNameList"]?.add(taskName);
    LocalDatabaseService.instance.saveTasksNameToBox(
      tasks["tasksNameList"] as List<String>,
    );
    fetchTasks();
  }

  void addTaskIsDoneList() {
    tasks["tasksIsDoneList"]?.add(false);
    LocalDatabaseService.instance.saveTasksIsDoneToBox(
      tasks["tasksIsDoneList"] as List<bool>,
    );
    fetchTasks();
  }

  void changeIsDone(int index) {
    tasks["tasksIsDoneList"]?[index] = !tasks["tasksIsDoneList"]?[index];
    LocalDatabaseService.instance.saveTasksIsDoneToBox(
      tasks["tasksIsDoneList"] as List<bool>,
    );
    fetchTasks();
  }

  Color getColor(int index) =>
      tasks["tasksIsDoneList"]?[index] ? Colors.green : Colors.black;
  // if (tasksIsDoneList[index]) {
  //   return Colors.green;
  // } else {
  //   return Colors.black;
  // }

  TextEditingController textEditingController = TextEditingController();

  void cleanTextEditingController() {
    textEditingController.clear();
  }

  void removeTask() {}
}
