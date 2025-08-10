import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:state_management_practice/data/datasources/task_repository_datasource.dart';
import 'package:state_management_practice/data/repositories/task_repository_impl.dart';
import 'package:state_management_practice/domain/repositories/task_repoository.dart';
import 'package:state_management_practice/domain/usecases/task_usecases.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../presentation/pages/auth/controllers/auth_controller.dart';
import '../../presentation/pages/home/controllers/home_controller.dart'; // Add this

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies that are needed app-wide
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);

    Get.put<Box<String>>(Hive.box<String>('tasks'), permanent: true);

    Get.put<AuthRemoteDataSource>(
      AuthFirebaseDataSource(Get.find<FirebaseAuth>()),
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
    );

    Get.put<TaskRepository>(
      TaskRepositoryImpl(Get.find<TaskRepositoryDataSource>()),
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

    // Add HomeController
    Get.put<HomeController>(
      HomeController(Get.find<TaskUseCases>()),
      permanent: true,
    );
  }
}
