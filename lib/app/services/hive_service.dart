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

  void saveSubTasksNameToBox(String key, List<String> subTasksNameList) {
    _tasksBox.put(key, subTasksNameList);
  }

  Map<String, List<dynamic>> getTasks() {
    return <String, List<dynamic>>{
      AppConstants.tasksNameListKey:
          _tasksBox.get(AppConstants.tasksNameListKey) ?? <String>[],
      AppConstants.tasksIsDoneListKey:
          _tasksBox.get(AppConstants.tasksIsDoneListKey) ?? <bool>[],
    };
  }

  Map<String, List<dynamic>> getSubTasks(String key) {
    return <String, List<dynamic>>{key: _tasksBox.get(key) ?? <String>[]};
  }

  void removeTaskFromBox(int index) {
    final Map<String, List<dynamic>> tasksMap = getTasks();
    tasksMap[AppConstants.tasksNameListKey]?.removeAt(index);
    tasksMap[AppConstants.tasksIsDoneListKey]?.removeAt(index);
    saveTasksNameToBox(
      tasksMap[AppConstants.tasksNameListKey]! as List<String>,
    );
    saveTasksIsDoneToBox(
      tasksMap[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
  }

  void removeSubTaskFromBox(int index) {
    final Map<String, List<dynamic>> SubTasksMap = getSubTasks();
    tasksMap[AppConstants.tasksNameListKey]?.removeAt(index);
    tasksMap[AppConstants.tasksIsDoneListKey]?.removeAt(index);
    saveTasksNameToBox(
      tasksMap[AppConstants.tasksNameListKey]! as List<String>,
    );
    saveTasksIsDoneToBox(
      tasksMap[AppConstants.tasksIsDoneListKey]! as List<bool>,
    );
  }
}
