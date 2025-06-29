import 'package:hive_flutter/hive_flutter.dart';
import 'package:state_management_practice/core/constants/app_constants.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  late Box<dynamic> _tasksBox;

  Future<void> initLocalDatabase() async {
    await Hive.initFlutter();
    _tasksBox = await Hive.openBox(AppConstants.tasksBox);
  }

  void saveTasksNameToBox(List<String> tasksNameList) {
    _tasksBox.put(AppConstants.tasksNameListKey, tasksNameList);
  }

  void saveTasksIsDoneToBox(List<bool> tasksIsDoneList) {
    _tasksBox.put(AppConstants.tasksIsDoneListKey, tasksIsDoneList);
  }

  void saveSubTasksNameToBox(
    String subTasksNameListKey,
    List<String> subTasksNameList,
  ) {
    _tasksBox.put(subTasksNameListKey, subTasksNameList);
  }

  void saveSubTaskIsDoneToBox(
    String subTasksNameListKey,
    List<bool> subTaskIsDoneList,
  ) {
    _tasksBox.put('${subTasksNameListKey}_done', subTaskIsDoneList);
  }

  List<String> getTasksNameList() {
    return _tasksBox.get(AppConstants.tasksNameListKey) ?? <String>[];
  }

  List<bool> getTasksIsDoneList() {
    return _tasksBox.get(AppConstants.tasksIsDoneListKey) ?? <bool>[];
  }

  List<String> getSubTasksList(String subTasksNameListKey) {
    return _tasksBox.get(subTasksNameListKey) ?? <String>[];
  }

  List<bool> getSubTaskIsDoneList(String subTasksNameListKey) {
    return _tasksBox.get('${subTasksNameListKey}_done') ?? <bool>[];
  }

  void removeTaskFromBox(int index) {
    final List<String> taskNameList = getTasksNameList();
    final List<bool> taskIsDoneList = getTasksIsDoneList();
    final String taskName = taskNameList[index];

    _tasksBox.delete(taskName);
    _tasksBox.delete('${taskName}_done');

    taskNameList.removeAt(index);
    taskIsDoneList.removeAt(index);

    saveTasksNameToBox(taskNameList);
    saveTasksIsDoneToBox(taskIsDoneList);
  }

  void removeSubTaskFromBox(String subTasksNameListKey, int index) {
    final List<String> subTasksNameList = getSubTasksList(subTasksNameListKey);
    final List<bool> subTaskIsDoneList = getSubTaskIsDoneList(
      "${subTasksNameListKey}_done",
    );

    subTasksNameList.removeAt(index);
    subTaskIsDoneList.removeAt(index);

    saveSubTasksNameToBox(subTasksNameListKey, subTasksNameList);
    saveSubTaskIsDoneToBox(subTasksNameListKey, subTaskIsDoneList);
  }
}
