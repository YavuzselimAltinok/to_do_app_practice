import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:state_management_practice/core/services/hive_service.dart';
import 'package:state_management_practice/firebase_options.dart';
import 'package:state_management_practice/modules/home/controllers/auth_controller.dart';
import 'package:state_management_practice/modules/home/controllers/home_controller.dart';
import 'package:state_management_practice/modules/home/views/home_view.dart';
import 'package:state_management_practice/modules/home/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.instance.initLocalDatabase();
  HomeController.instance.fetchTasks();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: (AuthController.instance.userIsLoggedIn()
              ? const HomeView()
              : const LoginView()),
        ),
      ),
    );
  }
}
