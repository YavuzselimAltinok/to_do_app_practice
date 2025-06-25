import 'package:flutter/material.dart';
import 'package:state_management_practice/app/services/hive_service.dart';
import 'package:state_management_practice/core/constants/app_constants.dart';

class Controller {
  Controller._();
  late Map<String, List<dynamic>> tasks;
  static final Controller instance = Controller._();

  void fetchTasks() {
    tasks = LocalDatabaseService.instance.getTasks();
  }

  void addTasksNameToList(String taskName) {
    tasks[AppConstants.tasksNameListKey]?.add(taskName);
    LocalDatabaseService.instance.saveTasksNameToBox(
      tasks[AppConstants.tasksNameListKey]! as List<String>,
    );
    fetchTasks();
  }

  void addTaskIsDoneList() {
    tasks[AppConstants.tasksIsDoneListKey]?.add(false);
    LocalDatabaseService.instance.saveTasksIsDoneToBox(
      tasks[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
    fetchTasks();
  }

  void addSubTasksNameList(String subTaskName) {
    tasks[AppConstants.tasksNameListKey]?.add(subTaskName);
    LocalDatabaseService.instance.saveTasksNameToBox(
      tasks[AppConstants.tasksNameListKey]! as List<String>,
    );
    fetchTasks();
  }

  void changeIsDone(int index) {
    tasks[AppConstants.tasksIsDoneListKey]?[index] =
        !tasks[AppConstants.tasksIsDoneListKey]?[index];
    LocalDatabaseService.instance.saveTasksIsDoneToBox(
      tasks[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
    fetchTasks();
  }

  Color getColor(int index) => tasks[AppConstants.tasksIsDoneListKey]?[index]
      ? Colors.green
      : Colors.black;
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

  void addExpansionTile(String tileName) {
    expansionTiles.add(tileName);
  }

  void removeTask(int index) {
    tasks[AppConstants.tasksNameListKey]?.removeAt(index);
    tasks[AppConstants.tasksIsDoneListKey]?.removeAt(index);
    LocalDatabaseService.instance.saveTasksNameToBox(
      tasks[AppConstants.tasksNameListKey]! as List<String>,
    );
    LocalDatabaseService.instance.saveTasksIsDoneToBox(
      tasks[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
  }

  double calculateListHeight() {
    final int taskCount = tasks[AppConstants.tasksNameListKey]?.length ?? 0;

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
