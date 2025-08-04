import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';

import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<AttendanceController>(() => AttendanceController(Get.find()));
  }
}
