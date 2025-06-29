import 'package:flutter/material.dart';
import 'package:state_management_practice/core/services/hive_service.dart';
import 'package:state_management_practice/modules/home/controllers/home_controller.dart';
import 'package:state_management_practice/modules/home/widgets/add_subtask_name_button.dart';
import 'package:state_management_practice/modules/home/widgets/add_task_name_button.dart';
import 'package:state_management_practice/modules/home/widgets/category_tile_widget.dart';
import 'package:state_management_practice/modules/home/widgets/custom_appbar.dart';
import 'package:state_management_practice/modules/home/widgets/empty_state_widget.dart';
import 'package:state_management_practice/modules/home/widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    HomeController.instance.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    HomeController.instance.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomAppbar(),
            Expanded(
              child: HomeController.instance.tasksNameList.isEmpty
                  ? const EmptyStateWidget()
                  : ListView.builder(
                      itemCount: HomeController.instance.tasksNameList.length,
                      itemBuilder: (BuildContext context, int tileIndex) {
                        return ExpansionTile(
                          backgroundColor: const Color.fromARGB(
                            28,
                            121,
                            121,
                            121,
                          ),
                          showTrailingIcon: false,
                          title: CategoryTileWidget(tileIndex: tileIndex),
                          children: <Widget>[
                            SizedBox(
                              height: HomeController.instance
                                  .calculateListHeight(tileIndex),
                              child: Stack(
                                children: <Widget>[
                                  ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return Task(
                                            // TODO : Modify to subtasks
                                            subTaskName: HiveService.instance
                                                .getSubTasksList(
                                                  HomeController
                                                      .instance
                                                      .tasksNameList[tileIndex],
                                                )[index],
                                            subTaskCondition: HiveService
                                                .instance
                                                .getSubTaskIsDoneList(
                                                  HomeController
                                                      .instance
                                                      .tasksNameList[tileIndex],
                                                )[index],
                                            onTapDoneButton: () {
                                              HomeController.instance
                                                  .changeSubTaskIsDone(
                                                    tileIndex,
                                                    index,
                                                  );
                                            },
                                            subtaskIcon: HomeController.instance
                                                .getSubTaskIcon(
                                                  tileIndex,
                                                  index,
                                                ),
                                            onTapRevomeSubTaskButton: () {
                                              HomeController.instance
                                                  .removeSubTaskFromBox(
                                                    tileIndex,
                                                    index,
                                                  );
                                            },
                                            subTaskTextStyle: HomeController
                                                .instance
                                                .getSubTaskTextStyle(
                                                  tileIndex,
                                                  index,
                                                ),
                                          );
                                        },
                                    itemCount: HiveService.instance
                                        .getSubTasksList(
                                          HomeController
                                              .instance
                                              .tasksNameList[tileIndex],
                                        )
                                        .length,
                                  ),
                                  AddSubtaskNameButton(tileIndex: tileIndex),
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
      floatingActionButton: const AddTaskNameButton(),
    );
  }
}
