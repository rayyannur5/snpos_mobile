import 'package:get/get.dart';

import '../controllers/attendance_transaction_controller.dart';

class AttendanceTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceTransactionController>( () => AttendanceTransactionController(Get.find()));
  }
}
