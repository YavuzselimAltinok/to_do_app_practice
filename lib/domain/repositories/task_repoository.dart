import '../entities/task_entity.dart';

abstract class TaskRepository {
  // Basic CRUD operations (matching your current HiveService)
  Future<List<TaskEntity>> getAllTasks();
  Future<void> saveTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);

  // Bulk operations
  Future<void> saveAllTasks(List<TaskEntity> tasks);
}
