import 'package:auto_size_text/auto_size_text.dart';
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
          children: <Widget>[
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
              child: Controller.instance.tasksNameList.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories yet.\nTap the + button to create your first category!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: Controller.instance.tasksNameList.length,
                      itemBuilder: (BuildContext context, int tileIndex) {
                        return ExpansionTile(
                          //TODO : Remove down arrow icon
                          //TODO : Add remove task button
                          title: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap:
                                    () {}, //TODO : Add functionality to change color
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 250,
                                child: AutoSizeText(
                                  minFontSize: 14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  Controller.instance.tasksNameList[tileIndex],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    letterSpacing: -0.17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            SizedBox(
                              height: Controller.instance.calculateListHeight(),
                              child: Stack(
                                children: <Widget>[
                                  ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return Task(
                                            // TODO : Modify to subtasks
                                            taskName: Controller
                                                .instance
                                                .tasksNameList[index],
                                            taskCondition: Controller
                                                .instance
                                                .tasksIsDoneList[index],
                                            onTapDoneButton: () {
                                              Controller.instance.changeIsDone(
                                                index,
                                              );
                                              setState(() {});
                                            },
                                            rectangleColor: Controller.instance
                                                .getColor(index),
                                            onTapRevomeTaskButton: () {
                                              Controller.instance.removeTask(
                                                index,
                                              );
                                              setState(() {});
                                            },
                                          );
                                        },
                                    itemCount: Controller
                                        .instance
                                        .tasksNameList
                                        .length,
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
                                            Controller.instance
                                                .cleanTextEditingController();
                                            return AlertDialog(
                                              title: const Text("Add New Task"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  TextField(
                                                    controller: Controller
                                                        .instance
                                                        .textEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText:
                                                              "Enter task details",
                                                        ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                FloatingActionButton(
                                                  onPressed: () {
                                                    Controller.instance
                                                        .addTasksNameToList(
                                                          Controller
                                                              .instance
                                                              .textEditingController
                                                              .text,
                                                        );
                                                    Controller.instance
                                                        .addTaskIsDoneList();
                                                    setState(() {});
                                                    Navigator.of(
                                                      dialogContext,
                                                    ).pop();
                                                  },
                                                  child: const Icon(
                                                    Icons.check,
                                                  ),
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              Controller.instance.cleanTileEditingController();
              return AlertDialog(
                title: const Text("Create New Category"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: Controller.instance.tileEditingController,
                      decoration: const InputDecoration(
                        hintText: "Enter category name",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                actions: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      if (Controller
                          .instance
                          .tileEditingController
                          .text
                          .isNotEmpty) {
                        setState(() {
                          // TODO : Add the new category to the list
                          Controller.instance.addTasksNameToList(
                            Controller.instance.tileEditingController.text,
                          );
                          Controller.instance.addTaskIsDoneList();
                        });
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: const Icon(Icons.check),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.category),
      ),
    );
  }
}
