import 'package:get/get.dart';
import 'package:state_management_practice/domain/usecases/task_usecases.dart';
import 'package:state_management_practice/presentation/pages/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(Get.find<TaskUseCases>()));
  }
}
