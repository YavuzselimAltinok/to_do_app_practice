import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class SaveTaskParams {
  SaveTaskParams({required this.task});

  final TaskEntity task;
}

class SaveTaskUseCase extends UseCase<void, SaveTaskParams> {
  SaveTaskUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<void> call(SaveTaskParams params) async {
    await taskRepository.saveTask(params.task);
  }
}
