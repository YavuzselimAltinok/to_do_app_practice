import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:state_management_practice/features/tasks/data/datasources/task_repository_datasource.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this.localDataSource, this.remoteDataSource);
  final TaskRepositoryDataSource localDataSource;
  final TaskRepositoryDataSource remoteDataSource;

  // Common connectivity check method
  Future<bool> get _isConnected async =>
      InternetConnectionChecker.instance.hasConnection;

  int _getAllTasksCounter = 0;
  String? _lastSyncedUserId;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final List<TaskModel> localTasks = await localDataSource.getAllTasks();
    final String? currentUserId = remoteDataSource.currentUserId;
    if (currentUserId != _lastSyncedUserId) {
      _lastSyncedUserId = currentUserId;
      final List<TaskModel> remoteTasks = await remoteDataSource.getAllTasks();
      return remoteTasks.map((TaskModel model) => model as TaskEntity).toList();
    }

    unawaited(_backgroundSync());

    return localTasks.map((TaskModel model) => model as TaskEntity).toList();
  }

  Future<void> _backgroundSync() async {
    final bool isConnected = await _isConnected;
    if (isConnected) {
      _getAllTasksCounter++;
      if (_getAllTasksCounter == 1) {
        final List<TaskModel> localTasks = await localDataSource.getAllTasks();
        final List<TaskModel> remoteTasks = await remoteDataSource
            .getAllTasks();
        await _syncTasks(localTasks, remoteTasks);
      }
    } else {
      _getAllTasksCounter = 0;
    }
  }

  Future<void> _syncTasks(
    List<TaskModel> localTasks,
    List<TaskModel> remoteTasks,
  ) async {
    // Create maps for O(1) lookup
    final Map<String, TaskModel> remoteMap = <String, TaskModel>{
      for (final TaskModel task in remoteTasks) task.id: task,
    };
    final Map<String, TaskModel> localMap = <String, TaskModel>{
      for (final TaskModel task in localTasks) task.id: task,
    };

    // Find tasks that exist locally but not remotely
    final List<TaskModel> tasksToUpload = <TaskModel>[];
    for (final TaskModel localTask in localTasks) {
      if (!remoteMap.containsKey(localTask.id)) {
        tasksToUpload.add(localTask);
      }
    }

    // Find tasks that exist remotely but not locally
    final List<TaskModel> tasksToDelete = <TaskModel>[];
    for (final TaskModel remoteTask in remoteTasks) {
      if (!localMap.containsKey(remoteTask.id)) {
        tasksToDelete.add(remoteTask);
      }
    }

    // Upload missing tasks to remote
    for (final TaskModel task in tasksToUpload) {
      try {
        await remoteDataSource.saveTask(task);
      } catch (e) {
        print('Failed to upload task ${task.id}: $e');
      }
    }

    // Delete tasks that exist remotely but not locally
    for (final TaskModel task in tasksToDelete) {
      try {
        await remoteDataSource.deleteTask(task.id);
      } catch (e) {
        print('Failed to delete task ${task.id}: $e');
      }
    }
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);

    unawaited(_backgroundSyncSave(taskModel));

    await localDataSource.saveTask(taskModel);
  }

  Future<void> _backgroundSyncSave(TaskModel task) async {
    final bool isConnected = await _isConnected;
    if (isConnected) {
      await remoteDataSource.saveTask(task);
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    unawaited(_backgroundSyncDelete(taskId));
    await localDataSource.deleteTask(taskId);
  }

  Future<void> _backgroundSyncDelete(String taskId) async {
    final bool isConnected = await _isConnected;
    if (isConnected) {
      await remoteDataSource.deleteTask(taskId);
    }
  }
}
