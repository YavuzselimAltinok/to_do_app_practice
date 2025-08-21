import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/core/constants/app_icons.dart';
import 'package:state_management_practice/core/constants/app_text_styles.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/usecases/task_usecases.dart';

class HomeController extends GetxController {
  HomeController(this.taskUseCases);
  final TaskUseCases taskUseCases;

  final RxList<TaskEntity> _tasks = <TaskEntity>[].obs;
  List<TaskEntity> get tasks => _tasks.toList();

  // Add loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController tileEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  // Public method to refresh data
  Future<void> refreshData() async {
    _isLoading.value = true;
    try {
      await fetchTasks();
    } catch (e) {
      throw Exception('HomeController: refreshData error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchTasks() async {
    final List<TaskEntity> tasks = await taskUseCases.getAllTasks();
    _tasks.value = tasks;
  }

  Future<void> createTask() async {
    if (tileEditingController.text.isNotEmpty) {
      await taskUseCases.createTask(tileEditingController.text);
      // Force reload tasks from storage after creating
      await fetchTasks();
      Get.back(); // Close the dialog or screen after creating
      cleanTileEditingController();
    }
  }

  Future<void> toggleTask(int index) async {
    final TaskEntity task = _tasks[index];

    final TaskEntity updatedTask = await taskUseCases.toggleTaskStatus(task);

    _tasks[index] = updatedTask;
  }

  Future<void> deleteTask(int index) async {
    final TaskEntity task = _tasks[index];
    await taskUseCases.deleteTask(task.id);
    _tasks.removeAt(index);
  }

  Future<void> addSubTask(int taskIndex) async {
    final TaskEntity task = _tasks[taskIndex];

    final TaskEntity updatedTask = await taskUseCases.addSubTask(
      task,
      textEditingController.text,
    );

    _tasks[taskIndex] = updatedTask;
    Get.back();
    cleanTextEditingController();
  }

  Future<void> toggleSubTask(int taskIndex, int subTaskIndex) async {
    final TaskEntity task = _tasks[taskIndex];

    final TaskEntity updatedTask = await taskUseCases.toggleSubTaskStatus(
      task,
      subTaskIndex,
    );

    _tasks[taskIndex] = updatedTask;
  }

  void removeSubTask(int taskIndex, int subTaskIndex) async {
    final TaskEntity task = _tasks[taskIndex];

    final TaskEntity updatedTask = await taskUseCases.removeSubTask(
      task,
      subTaskIndex,
    );

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
