import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/children/attendance_camera/views/attendance_camera_view.dart';

import '../controllers/camera_picker_controller.dart';

class CameraPickerView extends GetView<CameraPickerController> {
  const CameraPickerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return Stack(
          children: [
            // Fullscreen camera
            Positioned.fill(child: CameraPreview(controller.cameraController!)),

            // Tombol close
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),

            // Tombol capture
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 4), color: Get.theme.disabledColor),
                      child: Center(child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 7))),
                    );
                  } else {
                    return GestureDetector(
                      onTap: controller.capturePhoto,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 4), color: Colors.white),
                        child: Icon(Icons.camera),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
