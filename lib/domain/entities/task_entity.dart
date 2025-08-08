class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.name,
    required this.isDone,
    required this.subTasks,
  });
  final String id;
  final String name;
  final bool isDone;
  final List<SubTaskEntity> subTasks;

  // Only the business logic you actually need
  TaskEntity copyWith({
    String? id,
    String? name,
    bool? isDone,
    List<SubTaskEntity>? subTasks,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}

class SubTaskEntity {
  const SubTaskEntity({
    required this.id,
    required this.name,
    required this.isDone,
  });
  final String id;
  final String name;
  final bool isDone;

  SubTaskEntity copyWith({String? id, String? name, bool? isDone}) {
    return SubTaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
    );
  }
}
