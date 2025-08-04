import 'package:get/get.dart';

import '../controllers/attendance_camera_controller.dart';

class AttendanceCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceCameraController>(
      () => AttendanceCameraController(),
    );
  }
}
