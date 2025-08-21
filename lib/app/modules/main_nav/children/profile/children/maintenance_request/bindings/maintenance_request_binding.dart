import 'package:get/get.dart';

import '../controllers/maintenance_request_controller.dart';

class MaintenanceRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceRequestController>(
      () => MaintenanceRequestController(Get.find()),
    );
  }
}
