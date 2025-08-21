// lib/data/models/task_model.dart
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.name,
    required super.isDone,
    required super.subTasks,
  });

  // Convert from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      isDone: json['isDone'],
      subTasks: (json['subTasks'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic subTaskJson) =>
                SubTaskModel.fromJson(subTaskJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  // Convert from Entity to Model
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      name: entity.name,
      isDone: entity.isDone,
      subTasks: entity.subTasks.map(SubTaskModel.fromEntity).toList(),
    );
  }

  // Convert to JSON for Hive storage
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isDone': isDone,
      'subTasks': subTasks
          .map(
            (SubTaskEntity subTask) =>
                SubTaskModel.fromEntity(subTask).toJson(),
          )
          .toList(),
    };
  }
}

class SubTaskModel extends SubTaskEntity {
  const SubTaskModel({required super.name, required super.isDone});

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(name: json['name'], isDone: json['isDone']);
  }

  // Convert from Entity to Model
  factory SubTaskModel.fromEntity(SubTaskEntity entity) {
    return SubTaskModel(name: entity.name, isDone: entity.isDone);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'isDone': isDone};
  }
}
