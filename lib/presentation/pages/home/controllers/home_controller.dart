import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';
import 'package:state_management_practice/domain/entities/task_entity.dart';
import 'package:state_management_practice/domain/usecases/task_usecases.dart';

class HomeController extends GetxController {
  HomeController(this.taskUseCases);
  final TaskUseCases taskUseCases;

  final RxList<TaskEntity> _tasks = <TaskEntity>[].obs;
  List<TaskEntity> get tasks => _tasks.toList();

  TextEditingController textEditingController = TextEditingController();
  TextEditingController tileEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() async {
    final List<TaskEntity> tasks = await taskUseCases.getAllTasks();
    _tasks.value = tasks;
  }

  Future<void> saveTask(String taskName) async {
    final TaskEntity newTask = TaskEntity(
      id: DateTime.now().toIso8601String(),
      name: taskName,
      isDone: false,
      subTasks: <SubTaskEntity>[],
    );
    await taskUseCases.saveTask(newTask);
    _tasks.add(newTask);
  }

  Future<void> toggleTask(int index) async {
    final TaskEntity task = _tasks[index];
    final bool newIsDone = !task.isDone;

    // Update all subtasks to match the main task status (changeIsDone mechanic)
    final List<SubTaskEntity> updatedSubTasks = task.subTasks.map((
      SubTaskEntity subTask,
    ) {
      return subTask.copyWith(isDone: newIsDone);
    }).toList();

    // Update the main task with new status and updated subtasks
    final TaskEntity updatedTask = task.copyWith(
      isDone: newIsDone,
      subTasks: updatedSubTasks,
    );

    await taskUseCases.saveTask(updatedTask);
    _tasks[index] = updatedTask;
  }

  Future<void> deleteTask(int index) async {
    final TaskEntity task = _tasks[index];
    await taskUseCases.deleteTask(task.id);
    _tasks.removeAt(index);
  }

  Future<void> addSubTask(String subTaskName, int taskIndex) async {
    final TaskEntity task = _tasks[taskIndex];
    final SubTaskEntity newSubTask = SubTaskEntity(
      id: DateTime.now().toIso8601String(),
      name: subTaskName,
      isDone: false,
    );

    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    )..add(newSubTask);
    final TaskEntity updatedTask = task.copyWith(subTasks: updatedSubTasks);

    await taskUseCases.saveTask(updatedTask);
    _tasks[taskIndex] = updatedTask;
  }

  Future<void> toggleSubTask(int taskIndex, int subTaskIndex) async {
    final TaskEntity task = _tasks[taskIndex];
    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    );

    // Toggle the specific subtask
    updatedSubTasks[subTaskIndex] = updatedSubTasks[subTaskIndex].copyWith(
      isDone: !updatedSubTasks[subTaskIndex].isDone,
    );

    // Check if all subtasks are done to update main task status
    final bool allSubTasksDone = updatedSubTasks.every(
      (SubTaskEntity subTask) => subTask.isDone,
    );
    final bool anySubTaskUndone = updatedSubTasks.any(
      (SubTaskEntity subTask) => !subTask.isDone,
    );

    // Update main task status based on subtasks
    bool mainTaskIsDone = task.isDone;
    if (updatedSubTasks.isNotEmpty) {
      if (allSubTasksDone) {
        mainTaskIsDone = true; // All subtasks done = main task done
      } else if (anySubTaskUndone) {
        mainTaskIsDone = false; // Any subtask undone = main task undone
      }
    }

    final TaskEntity updatedTask = task.copyWith(
      isDone: mainTaskIsDone,
      subTasks: updatedSubTasks,
    );

    await taskUseCases.saveTask(updatedTask);
    _tasks[taskIndex] = updatedTask;
  }

  void removeSubTask(int taskIndex, int subTaskIndex) async {
    final TaskEntity task = _tasks[taskIndex];
    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    )..removeAt(subTaskIndex);
    final TaskEntity updatedTask = task.copyWith(subTasks: updatedSubTasks);

    await taskUseCases.saveTask(updatedTask);
    _tasks[taskIndex] = updatedTask;
  }

  // Convert your existing helper methods to use entities
  AssetImage getTaskIcon(int index) {
    if (index < 0 || index >= _tasks.length) {
      return const AssetImage(AppIcons.taskUndoneIcon);
    }
    return _tasks[index].isDone
        ? const AssetImage(AppIcons.taskDoneIcon)
        : const AssetImage(AppIcons.taskUndoneIcon);
  }

  TextStyle getTaskTextStyle(int index) {
    if (index < 0 || index >= _tasks.length) {
      return AppTextStyles.taskNameTextStyle;
    }
    return _tasks[index].isDone
        ? AppTextStyles.taskNameDoneTextStyle
        : AppTextStyles.taskNameTextStyle;
  }

  AssetImage getSubTaskIcon(int taskIndex, int subTaskIndex) {
    if (taskIndex < 0 || taskIndex >= _tasks.length) {
      return const AssetImage(AppIcons.subtaskUndoneIcon);
    }

    final TaskEntity task = _tasks[taskIndex];
    if (subTaskIndex < 0 || subTaskIndex >= task.subTasks.length) {
      return const AssetImage(AppIcons.subtaskUndoneIcon);
    }

    return task.subTasks[subTaskIndex].isDone
        ? const AssetImage(AppIcons.subtaskDoneIcon)
        : const AssetImage(AppIcons.subtaskUndoneIcon);
  }

  TextStyle getSubTaskTextStyle(int taskIndex, int subTaskIndex) {
    if (taskIndex < 0 || taskIndex >= _tasks.length) {
      return AppTextStyles.taskNameTextStyle;
    }

    final TaskEntity task = _tasks[taskIndex];
    if (subTaskIndex < 0 || subTaskIndex >= task.subTasks.length) {
      return AppTextStyles.taskNameTextStyle;
    }

    return task.subTasks[subTaskIndex].isDone
        ? AppTextStyles.taskNameDoneTextStyle
        : AppTextStyles.taskNameTextStyle;
  }

  void cleanTextEditingController() {
    textEditingController.clear();
  }

  void cleanTileEditingController() {
    tileEditingController.clear();
  }

  // Convert calculateListHeight to use entities
  double calculateListHeight(int tileIndex) {
    if (tileIndex < 0 || tileIndex >= _tasks.length) {
      return 80.0;
    }

    final int subTaskCount = _tasks[tileIndex].subTasks.length;

    if (subTaskCount == 0) {
      return 80.0; // Minimum height for the FloatingActionButton
    }

    // Estimate task item height
    const double estimatedTaskHeight = 56.0;
    const double fabHeight = 56.0; // FloatingActionButton height
    const double padding = 32.0; // Bottom padding for FAB

    final double totalHeight =
        (subTaskCount * estimatedTaskHeight) + fabHeight + padding;

    // Return the calculated height
    return totalHeight;
  }

  // Helper methods to get subtask data (replacing the old getter methods)
  List<SubTaskEntity> getSubTasks(int taskIndex) {
    if (taskIndex < 0 || taskIndex >= _tasks.length) {
      return <SubTaskEntity>[];
    }
    return _tasks[taskIndex].subTasks;
  }

  List<String> getSubTaskNames(int taskIndex) {
    return getSubTasks(
      taskIndex,
    ).map((SubTaskEntity subTask) => subTask.name).toList();
  }

  List<bool> getSubTaskIsDoneList(int taskIndex) {
    return getSubTasks(
      taskIndex,
    ).map((SubTaskEntity subTask) => subTask.isDone).toList();
  }
}
