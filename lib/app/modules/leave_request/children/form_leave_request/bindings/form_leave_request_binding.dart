import 'package:get/get.dart';

import '../controllers/form_leave_request_controller.dart';

class FormLeaveRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormLeaveRequestController>(
      () => FormLeaveRequestController(Get.find()),
    );
  }
}
