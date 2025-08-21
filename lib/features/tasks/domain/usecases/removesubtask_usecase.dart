import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class RemoveSubTaskParams {
  RemoveSubTaskParams({required this.task, required this.subTaskIndex});

  final TaskEntity task;
  final int subTaskIndex;
}

class RemoveSubTaskUseCase extends UseCase<TaskEntity, RemoveSubTaskParams> {
  RemoveSubTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<TaskEntity> call(RemoveSubTaskParams params) async {
    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      params.task.subTasks,
    )..removeAt(params.subTaskIndex);

    final TaskEntity updatedTask = params.task.copyWith(
      subTasks: updatedSubTasks,
    );
    await taskRepository.saveTask(updatedTask);
    return updatedTask;
  }
}
