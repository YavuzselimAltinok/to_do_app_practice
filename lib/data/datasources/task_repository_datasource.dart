// lib/data/datasources/task_local_datasource.dart
import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskRepositoryDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskHiveRepositoryDataSource implements TaskRepositoryDataSource {
  TaskHiveRepositoryDataSource(this.tasksBox);
  final Box<String> tasksBox;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final List<TaskModel> tasks = <TaskModel>[];

    for (final key in tasksBox.keys) {
      final String? taskJson = tasksBox.get(key);
      if (taskJson != null) {
        try {
          final Map<String, dynamic> taskMap =
              json.decode(taskJson) as Map<String, dynamic>;
          tasks.add(TaskModel.fromJson(taskMap));
        } catch (e) {
          print('Error parsing task: $e');
          // Skip corrupted data
        }
      }
    }

    return tasks;
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final String taskJson = json.encode(task.toJson());
    await tasksBox.put(task.id, taskJson);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    // Same as save for Hive
    await saveTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }
}
