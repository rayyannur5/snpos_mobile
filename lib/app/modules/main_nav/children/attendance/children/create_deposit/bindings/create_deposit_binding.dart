import 'package:get/get.dart';

import '../controllers/create_deposit_controller.dart';

class CreateDepositBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateDepositController>(
      () => CreateDepositController(Get.find()),
    );
  }
}
