import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:state_management_practice/core/constants/app_constants.dart';

class LocalDatabaseService {
  LocalDatabaseService._();
  static LocalDatabaseService instance = LocalDatabaseService._();

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
    String subTaskIsDoneListKey,
    List<bool> subTaskIsDoneList,
  ) {
    _tasksBox.put(subTaskIsDoneListKey, subTaskIsDoneList);
  }

  Map<String, List<dynamic>> getTasksMap() {
    return <String, List<dynamic>>{
      AppConstants.tasksNameListKey:
          _tasksBox.get(AppConstants.tasksNameListKey) ?? <String>[],
      AppConstants.tasksIsDoneListKey:
          _tasksBox.get(AppConstants.tasksIsDoneListKey) ?? <bool>[],
    };
  }

  List<String> getSubTasksList(String subTasksNameListKey) {
    return _tasksBox.get(subTasksNameListKey) ?? <String>[];
  }

  List<bool> getSubTaskIsDoneList(String subTaskIsDoneListKey) {
    return _tasksBox.get(subTaskIsDoneListKey) ?? <bool>[];
  }

  void removeTaskFromBox(int index) {
    final Map<String, List<dynamic>> tasksMap = getTasksMap();
    tasksMap[AppConstants.tasksNameListKey]?.removeAt(index);
    tasksMap[AppConstants.tasksIsDoneListKey]?.removeAt(index);
    saveTasksNameToBox(
      tasksMap[AppConstants.tasksNameListKey]! as List<String>,
    );
    saveTasksIsDoneToBox(
      tasksMap[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
  }

  void removeSubTaskFromBox(String subTasksNameListKey, int index) {
    final List<String> subTasksList = getSubTasksList(subTasksNameListKey);
    subTasksList.removeAt(index);
    saveSubTasksNameToBox(subTasksNameListKey, subTasksList);
  }

  void removeSubTaskIsDoneFromBox(String subTaskIsDoneListKey, int index) {
    final List<bool> subTaskIsDoneList = getSubTaskIsDoneList(
      subTaskIsDoneListKey,
    );
    subTaskIsDoneList.removeAt(index);
    saveSubTaskIsDoneToBox(subTaskIsDoneListKey, subTaskIsDoneList);
  }
}
