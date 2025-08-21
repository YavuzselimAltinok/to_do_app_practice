import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class ToggleSubTaskParams {
  ToggleSubTaskParams({required this.task, required this.subTaskIndex});

  final TaskEntity task;
  final int subTaskIndex;
}

class ToggleSubTaskUseCase extends UseCase<TaskEntity, ToggleSubTaskParams> {
  ToggleSubTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<TaskEntity> call(ToggleSubTaskParams params) async {
    final List<SubTaskEntity> subTasks = List<SubTaskEntity>.from(
      params.task.subTasks,
    );
    subTasks[params.subTaskIndex] = subTasks[params.subTaskIndex].copyWith(
      isDone: !subTasks[params.subTaskIndex].isDone,
    );
    // Check if all subtasks are done
    final bool allSubTasksDone = subTasks.every(
      (SubTaskEntity subTask) => subTask.isDone,
    );

    // Update main task status based on subtasks
    bool mainTaskIsDone = params.task.isDone;
    if (subTasks.isNotEmpty) {
      if (allSubTasksDone) {
        mainTaskIsDone = true; // All subtasks done = main task done
      } else {
        mainTaskIsDone = false; // Any subtask undone = main task undone
      }
    }
    final TaskEntity updatedTask = params.task.copyWith(
      isDone: mainTaskIsDone,
      subTasks: subTasks,
    );
    await taskRepository.saveTask(updatedTask);
    return updatedTask;
  }
}
