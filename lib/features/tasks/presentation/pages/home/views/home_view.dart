import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_practice/core/constants/app_colors.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/controllers/home_controller.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/add_subtask_name_button.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/add_task_name_button.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/category_tile_widget.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/custom_appbar.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/empty_state_widget.dart';
import 'package:state_management_practice/features/tasks/presentation/pages/home/widgets/subtask_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomAppbar(),
            Expanded(
              child: Obx(
                () => homeController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : homeController.tasks.isEmpty
                    ? const EmptyStateWidget()
                    : ListView.builder(
                        itemCount: homeController.tasks.length,
                        itemBuilder: (BuildContext context, int tileIndex) {
                          return ExpansionTile(
                            backgroundColor:
                                AppColors.expansionTileBackgroundColor,
                            showTrailingIcon: false,
                            title: CategoryTileWidget(tileIndex: tileIndex),
                            children: <Widget>[
                              SizedBox(
                                height: homeController.calculateListHeight(
                                  tileIndex,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            return SubTask(
                                              subTaskName: homeController
                                                  .getSubTasks(tileIndex)[index]
                                                  .name,
                                              subTaskCondition: homeController
                                                  .getSubTasks(tileIndex)[index]
                                                  .isDone,
                                              onTapDoneButton: () {
                                                homeController.toggleSubTask(
                                                  tileIndex,
                                                  index,
                                                );
                                              },
                                              subtaskIcon: homeController
                                                  .getSubTaskIcon(
                                                    tileIndex,
                                                    index,
                                                  ),
                                              onTapRevomeSubTaskButton: () {
                                                homeController.removeSubTask(
                                                  tileIndex,
                                                  index,
                                                );
                                              },
                                              subTaskTextStyle: homeController
                                                  .getSubTaskTextStyle(
                                                    tileIndex,
                                                    index,
                                                  ),
                                            );
                                          },
                                      itemCount: homeController
                                          .getSubTasks(tileIndex)
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
            ),
          ],
        ),
      ),
      floatingActionButton: const AddTaskNameButton(),
    );
  }
}
