import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class CreateTaskParams {
  CreateTaskParams({required this.taskName});

  final String taskName;
}

class CreateTaskUseCase extends UseCase<void, CreateTaskParams> {
  CreateTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<void> call(CreateTaskParams params) async {
    if (params.taskName.trim().isEmpty) {
      throw Exception('Task name cannot be empty');
    }
    final TaskEntity taskModel = TaskEntity(
      id: DateTime.now().toIso8601String(),
      name: params.taskName,
      isDone: false,
      subTasks: <SubTaskEntity>[],
    );
    await taskRepository.saveTask(taskModel);
  }
}
