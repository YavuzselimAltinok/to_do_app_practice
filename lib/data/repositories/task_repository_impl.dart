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
    return taskModels; // TaskModel extends TaskEntity, so this works
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    await localDataSource.saveTask(taskModel);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final TaskModel taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<void> saveAllTasks(List<TaskEntity> tasks) async {
    final List<TaskModel> taskModels = tasks
        .map((TaskEntity task) => TaskModel.fromEntity(task))
        .toList();
    await localDataSource.saveAllTasks(taskModels);
  }
}
