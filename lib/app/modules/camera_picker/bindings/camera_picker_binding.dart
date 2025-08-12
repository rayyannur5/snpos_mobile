import 'package:get/get.dart';

import '../controllers/camera_picker_controller.dart';

class CameraPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraPickerController>(
      () => CameraPickerController(),
    );
  }
}
