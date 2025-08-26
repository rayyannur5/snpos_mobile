import 'package:get/get.dart';
import 'package:snpos/app/modules/leave_request/providers/leave_request_provider.dart';

import '../controllers/leave_request_controller.dart';

class LeaveRequestBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LeaveRequestProvider>(
          () => LeaveRequestProvider(),
    );

    Get.lazyPut<LeaveRequestController>(
      () => LeaveRequestController(Get.find()),
    );
  }
}
