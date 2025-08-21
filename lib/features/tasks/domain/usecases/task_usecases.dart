import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';
import '../entities/task_entity.dart';

// TODO: Fix usecases format, each of them needs to be a class
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

  Future<void> createTask(String taskName) async {
    if (taskName.trim().isEmpty) {
      throw Exception('Task name cannot be empty');
    }
    final TaskEntity taskModel = TaskEntity(
      id: DateTime.now().toIso8601String(),
      name: taskName,
      isDone: false,
      subTasks: <SubTaskEntity>[],
    );
    await repository.saveTask(taskModel);
  }

  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      throw Exception('Task ID is required');
    }
    await repository.deleteTask(taskId);
  }

  // Additional helper methods based on your app needs
  Future<TaskEntity> toggleTaskStatus(TaskEntity task) async {
    final bool newIsDone = !task.isDone;
    final List<SubTaskEntity> updatedSubTasks = task.subTasks.map((
      SubTaskEntity subTask,
    ) {
      return subTask.copyWith(isDone: newIsDone);
    }).toList();

    final TaskEntity updatedTask = task.copyWith(
      isDone: newIsDone,
      subTasks: updatedSubTasks,
    );

    await saveTask(updatedTask);
    return updatedTask;
  }

  Future<TaskEntity> addSubTask(TaskEntity task, String subTaskName) async {
    final SubTaskEntity subTask = SubTaskEntity(
      name: subTaskName,
      isDone: false,
    );

    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    )..add(subTask);

    final TaskEntity updatedTask = task.copyWith(subTasks: updatedSubTasks);
    await saveTask(updatedTask);
    return updatedTask;
  }

  Future<TaskEntity> toggleSubTaskStatus(
    TaskEntity task,
    int subTaskIndex,
  ) async {
    final List<SubTaskEntity> subTasks = List<SubTaskEntity>.from(
      task.subTasks,
    );
    subTasks[subTaskIndex] = subTasks[subTaskIndex].copyWith(
      isDone: !subTasks[subTaskIndex].isDone,
    );
    // Check if all subtasks are done
    final bool allSubTasksDone = subTasks.every(
      (SubTaskEntity subTask) => subTask.isDone,
    );

    // Update main task status based on subtasks
    bool mainTaskIsDone = task.isDone;
    if (subTasks.isNotEmpty) {
      if (allSubTasksDone) {
        mainTaskIsDone = true; // All subtasks done = main task done
      } else {
        mainTaskIsDone = false; // Any subtask undone = main task undone
      }
    }
    final TaskEntity updatedTask = task.copyWith(
      isDone: mainTaskIsDone,
      subTasks: subTasks,
    );
    await saveTask(updatedTask);
    return updatedTask;
  }

  Future<TaskEntity> removeSubTask(TaskEntity task, int subTaskIndex) async {
    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      task.subTasks,
    )..removeAt(subTaskIndex);

    final TaskEntity updatedTask = task.copyWith(subTasks: updatedSubTasks);
    await saveTask(updatedTask);
    return updatedTask;
  }
}
