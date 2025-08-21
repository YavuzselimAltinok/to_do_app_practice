import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class ToggleTaskParams {
  ToggleTaskParams({required this.task});

  final TaskEntity task;
}

class ToggleTaskUseCase extends UseCase<TaskEntity, ToggleTaskParams> {
  ToggleTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<TaskEntity> call(ToggleTaskParams params) async {
    final bool newIsDone = !params.task.isDone;
    final List<SubTaskEntity> updatedSubTasks = params.task.subTasks.map((
      SubTaskEntity subTask,
    ) {
      return subTask.copyWith(isDone: newIsDone);
    }).toList();

    final TaskEntity updatedTask = params.task.copyWith(
      isDone: newIsDone,
      subTasks: updatedSubTasks,
    );

    await taskRepository.saveTask(updatedTask);
    return updatedTask;
  }
}
