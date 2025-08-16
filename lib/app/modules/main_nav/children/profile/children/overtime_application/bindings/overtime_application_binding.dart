import 'package:get/get.dart';

import '../controllers/overtime_application_controller.dart';

class OvertimeApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OvertimeApplicationController>(
      () => OvertimeApplicationController(Get.find()),
    );
  }
}
