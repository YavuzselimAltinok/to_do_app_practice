import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/tasks/domain/entities/task_entity.dart';
import 'package:state_management_practice/features/tasks/domain/repositories/task_repository.dart';

class GetAllTasksUseCase extends UseCase<List<TaskEntity>, void> {
  GetAllTasksUseCase(this.taskRepository);

  final TaskRepository taskRepository;

  @override
  Future<List<TaskEntity>> call(void params) async {
    return taskRepository.getAllTasks();
  }
}
