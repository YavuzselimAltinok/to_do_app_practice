import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:state_management_practice/app/bindings/initial_binding.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox<String>('tasks');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
    );
  }
}

String _getInitialRoute() {
  // Check if user is logged in using GetX dependency injection
  try {
    final AuthUseCases authUseCases = Get.find<AuthUseCases>();
    final UserEntity? currentUser = authUseCases.repository.getCurrentUser();
    return currentUser != null ? AppRoutes.home : AppRoutes.login;
  } catch (e) {
    // If dependencies aren't ready yet, default to login
    return AppRoutes.login;
  }
}
