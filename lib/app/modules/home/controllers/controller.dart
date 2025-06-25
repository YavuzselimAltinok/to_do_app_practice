import 'package:flutter/material.dart';
import 'package:state_management_practice/app/services/hive_service.dart';

class Controller {
  Controller._();
  List<String> tasksNameList = <String>[];
  List<bool> tasksIsDoneList = <bool>[];
  late List<String> subTasksList;
  late List<bool> subTaskIsDoneList;

  static final Controller instance = Controller._();

  void fetchTasks() {
    tasksNameList = LocalDatabaseService.instance.getTasksNameList();
    tasksIsDoneList = LocalDatabaseService.instance.getTasksIsDoneList();
  }

  void addTasksNameToList(String taskName) {
    tasksNameList.add(taskName);
    LocalDatabaseService.instance.saveTasksNameToBox(tasksNameList);
    fetchTasks();
  }

  void addTaskIsDoneList() {
    tasksIsDoneList.add(false);
    LocalDatabaseService.instance.saveTasksIsDoneToBox(tasksIsDoneList);
    fetchTasks();
  }

  void addSubTasksNameList(String key, String subTaskName) {
    subTasksList.add(subTaskName);
    LocalDatabaseService.instance.saveSubTasksNameToBox(key, subTasksList);
    fetchTasks();
  }

  void addSubTaskIsDoneList(String key, bool subTaskIsDone) {
    subTaskIsDoneList.add(subTaskIsDone);
    LocalDatabaseService.instance.saveSubTaskIsDoneToBox(
      key,
      subTaskIsDoneList,
    );
    fetchTasks();
  }

  void changeIsDone(int index) {
    tasksIsDoneList[index] = !tasksIsDoneList[index];
    LocalDatabaseService.instance.saveTasksIsDoneToBox(tasksIsDoneList);
    fetchTasks();
  }

  Color getColor(int index) =>
      tasksIsDoneList[index] ? Colors.green : Colors.black;
  // if (tasksIsDoneList[index]) {
  //   return Colors.green;
  // } else {
  //   return Colors.black;
  // }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController tileEditingController = TextEditingController();

  void cleanTextEditingController() {
    textEditingController.clear();
  }

  void cleanTileEditingController() {
    tileEditingController.clear();
  }

  void removeTask(int index) {
    tasksNameList.removeAt(index);
    tasksIsDoneList.removeAt(index);
    LocalDatabaseService.instance.saveTasksNameToBox(tasksNameList);
    LocalDatabaseService.instance.saveTasksIsDoneToBox(tasksIsDoneList);
  }

  double calculateListHeight() {
    final int taskCount = tasksIsDoneList.length;

    if (taskCount == 0) {
      return 80.0; // Minimum height for the FloatingActionButton
    }

    // Estimate task item height (you might need to adjust this based on your Task widget height)
    const double estimatedTaskHeight = 56.0;
    const double fabHeight = 56.0; // FloatingActionButton height
    const double padding = 32.0; // Bottom padding for FAB

    final double totalHeight =
        (taskCount * estimatedTaskHeight) + fabHeight + padding;

    // Return the calculated height, but cap it at 400
    return totalHeight;
  }
}
