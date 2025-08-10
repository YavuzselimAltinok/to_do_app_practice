import 'package:state_management_practice/data/datasources/task_repository_datasource.dart';
import 'package:state_management_practice/domain/repositories/task_repoository.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this.localDataSource);
  final TaskRepositoryDataSource localDataSource;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final List<TaskModel> taskModels = await localDataSource.getAllTasks();
    // Convert TaskModels to TaskEntities explicitly
    return taskModels.map((TaskModel model) => model as TaskEntity).toList();
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    await localDataSource.saveTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }
}
