import 'package:state_management_practice/domain/repositories/task_repository.dart';

import '../entities/task_entity.dart';

class TaskUseCases {
  TaskUseCases(this.repository);
  final TaskRepository repository;

  Future<List<TaskEntity>> getAllTasks() async {
    return repository.getAllTasks();
  }

  Future<void> saveTask(TaskEntity task) async {
    if (task.name.trim().isEmpty) {
      throw Exception('Task name cannot be empty');
    }
    await repository.saveTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      throw Exception('Task ID is required');
    }
    await repository.deleteTask(taskId);
  }

  // Additional helper methods based on your app needs
  Future<void> toggleTaskStatus(TaskEntity task) async {
    final TaskEntity updatedTask = task.copyWith(isDone: !task.isDone);
    await saveTask(updatedTask);
  }

  Future<void> addSubTask(TaskEntity task, SubTaskEntity subTask) async {
    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    )..add(subTask);
    final TaskEntity updatedTask = task.copyWith(subTasks: updatedSubTasks);
    await saveTask(updatedTask);
  }

  Future<void> toggleSubTaskStatus(TaskEntity task, int subTaskIndex) async {
    final List<SubTaskEntity> subTasks = List<SubTaskEntity>.from(
      task.subTasks,
    );
    subTasks[subTaskIndex] = subTasks[subTaskIndex].copyWith(
      isDone: !subTasks[subTaskIndex].isDone,
    );
    final TaskEntity updatedTask = task.copyWith(subTasks: subTasks);
    await saveTask(updatedTask);
  }
}
