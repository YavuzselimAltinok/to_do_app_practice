import 'package:flutter/material.dart';
import 'package:state_management_practice/core/services/hive_service.dart';

class HomeController extends ChangeNotifier {
  HomeController._();
  static final HomeController instance = HomeController._();
  List<String> tasksNameList = <String>[];
  List<bool> tasksIsDoneList = <bool>[];

  void fetchTasks() {
    tasksNameList = HiveService.instance.getTasksNameList();
    tasksIsDoneList = HiveService.instance.getTasksIsDoneList();
    notifyListeners();
  }

  void addTasksNameToList(String taskName) {
    tasksNameList.add(taskName);
    HiveService.instance.saveTasksNameToBox(tasksNameList);
    HiveService.instance.saveSubTasksNameToBox(taskName, <String>[]);
    HiveService.instance.saveSubTaskIsDoneToBox(taskName, <bool>[]);
    fetchTasks();
  }

  void addTaskIsDoneList() {
    tasksIsDoneList.add(false);
    HiveService.instance.saveTasksIsDoneToBox(tasksIsDoneList);
    fetchTasks();
  }

  void addSubTasksNameList(String subTaskName, int index) {
    final List<String> subTasksList = HiveService.instance.getSubTasksList(
      tasksNameList[index],
    );
    subTasksList.add(subTaskName);
    HiveService.instance.saveSubTasksNameToBox(
      tasksNameList[index],
      subTasksList,
    );
    fetchTasks();
  }

  void addSubTaskIsDoneList(int index) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[index]);
    subTaskIsDoneList.add(false);
    HiveService.instance.saveSubTaskIsDoneToBox(
      tasksNameList[index],
      subTaskIsDoneList,
    );
    fetchTasks();
  }

  void changeIsDone(int index) {
    tasksIsDoneList[index] = !tasksIsDoneList[index];
    HiveService.instance.saveTasksIsDoneToBox(tasksIsDoneList);
    fetchTasks();
  }

  void changeSubTaskIsDone(int taskIndex, int subTaskIndex) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);
    subTaskIsDoneList[subTaskIndex] = !subTaskIsDoneList[subTaskIndex];
    HiveService.instance.saveSubTaskIsDoneToBox(
      tasksNameList[taskIndex],
      subTaskIsDoneList,
    );
    fetchTasks();
  }

  AssetImage getTaskIcon(int index) {
    return tasksIsDoneList[index]
        ? const AssetImage('assets/icons/task_done_icon.png')
        : const AssetImage('assets/icons/task_undone_icon.png');
  }

  TextStyle getTaskTextStyle(int index) {
    return tasksIsDoneList[index]
        ? const TextStyle(
            fontSize: 18,
            letterSpacing: -0.17,
            decoration: TextDecoration.lineThrough,
            color: Color.fromARGB(255, 73, 73, 73),
          )
        : const TextStyle(fontSize: 18, letterSpacing: -0.17);
  }

  AssetImage getSubTaskIcon(int taskIndex, int subTaskIndex) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);
    return subTaskIsDoneList[subTaskIndex]
        ? const AssetImage('assets/icons/subtask_done_icon.png')
        : const AssetImage('assets/icons/subtask_undone_icon.png');
  }

  TextStyle getSubTaskTextStyle(int taskIndex, int subTaskIndex) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);
    return subTaskIsDoneList[subTaskIndex]
        ? const TextStyle(
            fontSize: 18,
            letterSpacing: -0.17,
            decoration: TextDecoration.lineThrough,
            color: Color.fromARGB(255, 73, 73, 73),
          )
        : const TextStyle(fontSize: 18, letterSpacing: -0.17);
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController tileEditingController = TextEditingController();

  void cleanTextEditingController() {
    textEditingController.clear();
  }

  void cleanTileEditingController() {
    tileEditingController.clear();
  }

  void removeTaskFromBox(int index) {
    HiveService.instance.removeTaskFromBox(index);
    fetchTasks();
  }

  void removeSubTaskFromBox(int taskIndex, int subTaskIndex) {
    final List<String> subTasksList = HiveService.instance.getSubTasksList(
      tasksNameList[taskIndex],
    );
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);

    subTasksList.removeAt(subTaskIndex);
    subTaskIsDoneList.removeAt(subTaskIndex);

    HiveService.instance.saveSubTasksNameToBox(
      tasksNameList[taskIndex],
      subTasksList,
    );
    HiveService.instance.saveSubTaskIsDoneToBox(
      tasksNameList[taskIndex],
      subTaskIsDoneList,
    );

    fetchTasks();
  }

  double calculateListHeight(int tileIndex) {
    final int taskCount = HiveService.instance
        .getSubTaskIsDoneList(HomeController.instance.tasksNameList[tileIndex])
        .length;

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
