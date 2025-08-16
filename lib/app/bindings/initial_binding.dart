import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:state_management_practice/data/datasources/task_repository_datasource.dart';
import 'package:state_management_practice/data/repositories/task_repository_impl.dart';
import 'package:state_management_practice/domain/repositories/task_repository.dart';
import 'package:state_management_practice/domain/usecases/task_usecases.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../presentation/pages/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies that are needed app-wide
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);

    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    Get.put<Box<String>>(Hive.box<String>('tasks'), permanent: true);

    Get.put<AuthRemoteDataSource>(
      AuthFirebaseDataSource(
        Get.find<FirebaseAuth>(),
        Get.find<FirebaseFirestore>(),
      ),
      permanent: true,
    );

    Get.put<AuthRepository>(
      AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      permanent: true,
    );

    Get.put<AuthUseCases>(
      AuthUseCases(Get.find<AuthRepository>()),
      permanent: true,
    );

    // Task dependencies
    Get.put<TaskRepositoryDataSource>(
      TaskHiveRepositoryDataSource(Get.find<Box<String>>()),
      permanent: true,
      tag: "local",
    );

    Get.put<TaskRepositoryDataSource>(
      TaskFirestoreRepositoryDataSource(
        Get.find<FirebaseFirestore>(),
        Get.find<FirebaseAuth>(),
      ),
      permanent: true,
      tag: "remote",
    );

    Get.put<TaskRepository>(
      TaskRepositoryImpl(
        Get.find<TaskRepositoryDataSource>(
          tag: "local",
        ), // ← First parameter (local)
        Get.find<TaskRepositoryDataSource>(
          tag: "remote",
        ), // ← Second parameter (remote)
      ),
      permanent: true,
    );

    Get.put<TaskUseCases>(
      TaskUseCases(Get.find<TaskRepository>()),
      permanent: true,
    );

    // Controllers
    Get.put<AuthController>(
      AuthController(Get.find<AuthUseCases>()),
      permanent: true,
    );
  }
}
