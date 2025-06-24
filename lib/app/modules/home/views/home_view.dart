import 'package:flutter/material.dart';
import 'package:state_management_practice/app/modules/home/controllers/controller.dart';
import 'package:state_management_practice/app/modules/home/widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'tasked',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Action_Man',
                      fontStyle: FontStyle.italic,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Task(
                        taskName:
                            Controller.instance.tasks["tasksNameList"]?[index],
                        taskCondition: Controller
                            .instance
                            .tasks["tasksIsDoneList"]?[index],
                        onTapDoneButton: () {
                          Controller.instance.changeIsDone(index);
                          setState(() {});
                        },
                        rectangleColor: Controller.instance.getColor(index),
                        onTapRevomeTaskButton: () {
                          Controller.instance.removeTask(index);
                          setState(() {});
                        },
                      );
                    },
                    itemCount:
                        Controller.instance.tasks["tasksNameList"]?.length,
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            Controller.instance.cleanTextEditingController();
                            return AlertDialog(
                              title: const Text("Add New Task"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: Controller
                                        .instance
                                        .textEditingController,
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
                                      Controller
                                          .instance
                                          .textEditingController
                                          .text,
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
          ],
        ),
      ),
    );
  }
}
