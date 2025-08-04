import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_camera_controller.dart';

class AttendanceCameraView extends GetView<AttendanceCameraController> {
  const AttendanceCameraView({super.key});
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

            // Overlay masker gelap dengan lubang oval di tengah
            Positioned.fill(child: CustomPaint(painter: OvalHolePainter())),

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

class OvalHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);
    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Tentukan posisi oval (misalnya tengah layar)
    final ovalWidth = size.width * 0.7;
    final ovalHeight = size.height * 0.5;
    final ovalRect = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: ovalWidth, height: ovalHeight);

    final holePath = Path()..addOval(ovalRect);
    final combined = Path.combine(PathOperation.difference, overlayPath, holePath);

    canvas.drawPath(combined, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
