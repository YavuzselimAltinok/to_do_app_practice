import 'package:flutter/material.dart';
import 'controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(27.0),
          child: Text(
            'tasked',
            style: TextStyle(fontSize: 32, letterSpacing: -0.41),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Task(
                  taskName: Controller.instance.tasksNameList[index],
                  taskCondition: Controller.instance.tasksIsDoneList[index],
                  onTapDoneButton: () {
                    Controller.instance.changeIsDone(index);
                    setState(() {});
                  },
                  rectangleColor: Controller.instance.getColor(index),
                );
              },
              itemCount: Controller.instance.tasksNameList.length,
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.plus_one),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text("Add New Task"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller:
                                  Controller.instance.textEditingController,
                              decoration: const InputDecoration(
                                hintText: "Enter task details",
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        actions: <Widget>[
                          FloatingActionButton(
                            onPressed: () {
                              Controller.instance.addTasksNameToList(
                                Controller.instance.textEditingController.text,
                              );
                              Controller.instance.addTaskIsDoneList();
                              setState(() {});
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Icon(Icons.check),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task extends StatefulWidget {
  const Task({
    super.key,
    required this.taskName,
    required this.taskCondition,
    required this.onTapDoneButton,
    required this.rectangleColor,
  });

  final String taskName;
  final bool taskCondition;
  final VoidCallback onTapDoneButton;
  final Color rectangleColor;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 24),
            GestureDetector(
              onTap: widget.onTapDoneButton,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: widget.rectangleColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              widget.taskName,
              style: const TextStyle(fontSize: 18, letterSpacing: -0.17),
            ),
          ],
        ),
      ),
    );
  }
}
