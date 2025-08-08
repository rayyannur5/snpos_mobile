import 'package:get/get.dart';

import '../controllers/schedule_information_controller.dart';

class ScheduleInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleInformationController>(
      () => ScheduleInformationController(Get.find()),
    );
  }
}
