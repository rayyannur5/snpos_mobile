import 'package:get/get.dart';

import '../controllers/maintenance_approval_controller.dart';

class MaintenanceApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceApprovalController>(
      () => MaintenanceApprovalController(Get.find()),
    );
  }
}
