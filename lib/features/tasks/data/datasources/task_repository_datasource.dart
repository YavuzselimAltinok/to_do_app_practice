// lib/data/datasources/task_local_datasource.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskRepositoryDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  String? get currentUserId;
}

class TaskHiveRepositoryDataSource implements TaskRepositoryDataSource {
  TaskHiveRepositoryDataSource(this._tasksBox);
  final Box<String> _tasksBox;

  @override
  String? get currentUserId => null; // TODO: Implement user ID retrieval

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final List<TaskModel> tasks = <TaskModel>[];

    for (final key in _tasksBox.keys) {
      final String? taskJson = _tasksBox.get(key);
      if (taskJson != null) {
        try {
          final Map<String, dynamic> taskMap =
              json.decode(taskJson) as Map<String, dynamic>;
          tasks.add(TaskModel.fromJson(taskMap));
        } catch (e) {
          print('Error parsing task: $e');
          // Skip corrupted data
        }
      }
    }

    return tasks;
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final String taskJson = json.encode(task.toJson());
    await _tasksBox.put(task.id, taskJson);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksBox.delete(taskId);
  }
}

class TaskFirestoreRepositoryDataSource implements TaskRepositoryDataSource {
  TaskFirestoreRepositoryDataSource(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _tasksCollection {
    if (currentUserId != null) {
      return _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('tasks');
    }
    throw Exception('User not authenticated');
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      if (currentUserId == null) {
        return <TaskModel>[];
      }

      final QuerySnapshot snapshot = await _tasksCollection.get();

      if (snapshot.docs.isEmpty) {
        return <TaskModel>[];
      }

      return snapshot.docs
          .map(
            (QueryDocumentSnapshot<Object?> doc) =>
                TaskModel.fromJson(doc.data()! as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks from Firebase: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await _tasksCollection.doc(task.id).set(task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
