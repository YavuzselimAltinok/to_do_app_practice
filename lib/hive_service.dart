import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseService {
  LocalDatabaseService._();
  static LocalDatabaseService instance = LocalDatabaseService._();

  late Box<dynamic> _tasksBox;

  Future<void> initLocalDatabase() async {
    await Hive.initFlutter();
    _tasksBox = await Hive.openBox("tasks_box");
  }

  void saveTasksNameToBox(List<String> tasksNameList) {
    _tasksBox.put("tasksNameList", tasksNameList);
  }

  void saveTasksIsDoneToBox(List<bool> tasksIsDoneList) {
    _tasksBox.put("tasksIsDoneList", tasksIsDoneList);
  }

  Map<String, List<dynamic>> getTasks() {
    return {
      "tasksNameList": _tasksBox.get("tasksNameList") ?? <String>[],
      "tasksIsDoneList": _tasksBox.get("tasksIsDoneList") ?? <bool>[],
    };
  }

  void removeTaskFromBox(int index) {
    final Map<String, List<dynamic>> tasksMap = getTasks();
    tasksMap["taskNameList"]?.removeAt(index);
    tasksMap["tasksIsDoneList"]?.removeAt(index);
    saveTasksNameToBox(tasksMap["taskNameList"]! as List<String>);
    saveTasksIsDoneToBox(tasksMap["tasksIsDoneList"]! as List<bool>);
  }
}
