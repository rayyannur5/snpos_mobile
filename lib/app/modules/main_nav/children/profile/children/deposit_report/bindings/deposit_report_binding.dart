import 'package:get/get.dart';

import '../controllers/deposit_report_controller.dart';

class DepositReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositReportController>(
      () => DepositReportController(Get.find()),
    );
  }
}
