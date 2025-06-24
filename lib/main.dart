import 'package:flutter/material.dart';
import 'package:state_management_practice/app/modules/home/views/home_view.dart';
import 'package:state_management_practice/app/services/hive_service.dart';
import 'app/modules/home/controllers/controller.dart';

void main() async {
  await LocalDatabaseService.instance.initLocalDatabase();
  Controller.instance.fetchTasks();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
