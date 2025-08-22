import 'package:get/get.dart';

import '../controllers/form_item_request_controller.dart';

class FormItemRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormItemRequestController>(
      () => FormItemRequestController(Get.find()),
    );
  }
}
