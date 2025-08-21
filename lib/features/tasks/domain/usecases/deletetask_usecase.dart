import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskParams {
  DeleteTaskParams({required this.taskId});

  final String taskId;
}

class DeleteTaskUseCase extends UseCase<void, DeleteTaskParams> {
  DeleteTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<void> call(DeleteTaskParams params) async {
    await taskRepository.deleteTask(params.taskId);
  }
}
