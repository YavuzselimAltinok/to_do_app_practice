import 'package:flutter/material.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';
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

  List<String> subTasksListGetter(String subTasksNameListKey) {
    return HiveService.instance.getSubTasksList(subTasksNameListKey);
  }

  List<bool> subTaskIsDoneListGetter(String subTaskIsDoneListKey) {
    return HiveService.instance.getSubTaskIsDoneList(subTaskIsDoneListKey);
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
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[index]);
    if (tasksIsDoneList[index]) {
      subTaskIsDoneList.fillRange(0, subTaskIsDoneList.length, true);
      HiveService.instance.saveSubTaskIsDoneToBox(
        tasksNameList[index],
        subTaskIsDoneList,
      );
    } else {
      subTaskIsDoneList.fillRange(0, subTaskIsDoneList.length, false);
      HiveService.instance.saveSubTaskIsDoneToBox(
        tasksNameList[index],
        subTaskIsDoneList,
      );
    }
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
    if (!subTaskIsDoneList.contains(false)) {
      tasksIsDoneList[taskIndex] = true;
    } else {
      tasksIsDoneList[taskIndex] = false;
    }
    fetchTasks();
  }

  AssetImage getTaskIcon(int index) {
    return tasksIsDoneList[index]
        ? const AssetImage(AppIcons.taskDoneIcon)
        : const AssetImage(AppIcons.taskUndoneIcon);
  }

  TextStyle getTaskTextStyle(int index) {
    return tasksIsDoneList[index]
        ? AppTextStyles.taskNameDoneTextStyle
        : AppTextStyles.taskNameTextStyle;
  }

  AssetImage getSubTaskIcon(int taskIndex, int subTaskIndex) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);
    return subTaskIsDoneList[subTaskIndex]
        ? const AssetImage(AppIcons.subtaskDoneIcon)
        : const AssetImage(AppIcons.subtaskUndoneIcon);
  }

  TextStyle getSubTaskTextStyle(int taskIndex, int subTaskIndex) {
    final List<bool> subTaskIsDoneList = HiveService.instance
        .getSubTaskIsDoneList(tasksNameList[taskIndex]);
    return subTaskIsDoneList[subTaskIndex]
        ? AppTextStyles.taskNameDoneTextStyle
        : AppTextStyles.taskNameTextStyle;
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
