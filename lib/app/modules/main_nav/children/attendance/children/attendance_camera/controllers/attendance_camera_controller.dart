import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:snpos/app/routes/app_pages.dart';

class AttendanceCameraController extends GetxController {
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
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('Kamera depan tidak ditemukan'),
      );

      cameraController = CameraController(
        frontCamera,
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

      Position? position = await getCurrentLocation();
      print(position);

      if(position == null) {
        isLoading.value = false;
        return;
      }

      String namedLocation = await getAddressFromPosition(position) ?? '';

      final file = await cameraController!.takePicture();
      final appDir = await getApplicationDocumentsDirectory();
      final String name = 'CAP-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
      final savedFile = await File(file.path).copy('${appDir.path}/$name');

      Get.snackbar(
        'Berhasil',
        'Foto berhasil disimpan!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(
          Routes.ATTENDANCE_TRANSACTION,
          arguments: {
              'pathFile' : savedFile.path,
              'location' : position,
              'namedLocation' : namedLocation
          }
      );

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

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('GPS tidak aktif', 'Silakan aktifkan lokasi');
      return null;
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Izin Lokasi Ditolak', 'Tidak bisa mengakses lokasi');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Izin Lokasi Ditolak Permanen', 'Buka pengaturan untuk mengizinkan');
      return null;
    }

    // Ambil posisi
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position.isMocked) {
      Get.snackbar(
        'Lokasi Palsu Terdeteksi',
        'Tidak dapat melanjutkan dengan lokasi palsu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    return position;
  }

  Future<String?> getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = '${placemark.street}, ${placemark.locality}, '
            '${placemark.administrativeArea}, ${placemark.country}';
        return address;
      } else {
        return 'Alamat tidak ditemukan';
      }
    } catch (e) {
      Get.snackbar(
        'Error Geocoding',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return 'Gagal mendapatkan alamat';
    }
  }


}
