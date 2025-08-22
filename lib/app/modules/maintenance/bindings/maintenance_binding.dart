import 'package:get/get.dart';
import 'package:snpos/app/modules/maintenance/providers/maintenance_provider.dart';
import 'package:snpos/app/modules/maintenance/providers/maintenance_provider.dart';

import '../controllers/maintenance_controller.dart';

class MaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceProvider>(() => MaintenanceProvider());
    Get.lazyPut<MaintenanceController>(
      () => MaintenanceController(Get.find()),
    );
  }
}
