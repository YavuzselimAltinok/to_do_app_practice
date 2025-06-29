import 'package:flutter/material.dart';
import 'package:state_management_practice/core/services/hive_service.dart';
import 'package:state_management_practice/modules/home/controllers/home_controller.dart';
import 'package:state_management_practice/modules/home/views/home_view.dart';

void main() async {
  await HiveService.instance.initLocalDatabase();
  HomeController.instance.fetchTasks();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: HomeView())),
    );
  }
}
