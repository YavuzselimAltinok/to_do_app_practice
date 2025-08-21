import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class AddSubTaskParams {
  AddSubTaskParams({required this.task, required this.subTaskName});

  final TaskEntity task;
  final String subTaskName;
}

class AddSubTaskUseCase extends UseCase<TaskEntity, AddSubTaskParams> {
  AddSubTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<TaskEntity> call(AddSubTaskParams params) async {
    final SubTaskEntity subTask = SubTaskEntity(
      name: params.subTaskName,
      isDone: false,
    );

    final List<SubTaskEntity> updatedSubTasks = List<SubTaskEntity>.from(
      params.task.subTasks,
    )..add(subTask);

    final TaskEntity updatedTask = params.task.copyWith(
      subTasks: updatedSubTasks,
    );
    await taskRepository.saveTask(updatedTask);
    return updatedTask;
  }
}
