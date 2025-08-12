import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CameraPickerController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => throw Exception('Kamera depan tidak ditemukan'),
      );

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar(
        'Gagal Membuka Kamera',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  Future<void> capturePhoto() async {
    try {

      isLoading.value = true;

      final file = await cameraController!.takePicture();
      final appDir = await getApplicationDocumentsDirectory();
      final String name = 'CAP_TRX-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
      final savedFile = await File(file.path).copy('${appDir.path}/$name');


      Get.back(result: savedFile.path);

      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal mengambil foto',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
