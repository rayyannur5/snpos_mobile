import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class AttendanceTransactionController extends GetxController {
  final AttendanceProvider provider;
  AttendanceTransactionController(this.provider);

  late final Position location;
  late final String pathFile;
  late final String namedLocation;

  var selectedShift = 0.obs;
  var shifts = [].obs;

  var selectedOutlet = 0.obs;
  var outlets = [].obs;

  var sendLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getShifts();
    getOutlets();

    final args = Get.arguments as Map;
    location = args['location'];
    pathFile = args['pathFile'];
    namedLocation = args['namedLocation'];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getShifts() async {
    var response = await provider.getShifts();
    if(response.statusCode == 200) {
      shifts.value = response.body['data'] ?? [];
    } else {
      Get.snackbar('Error fetch shifts', '${response.body.message}', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void selectShift(shift) {
    selectedShift.value = shift;
  }

  void getOutlets() async {
    var response = await provider.getOutlets();
    if(response.statusCode == 200) {
      outlets.value = response.body['data'] ?? [];
    } else {
      Get.snackbar('Error fetch outlets', '${response.body.message}', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void selectOutlet(outlet) {
    selectedOutlet.value = outlet;
  }

  void sendAttendance() async {
    sendLoading.value = true;
    try{

      if (selectedOutlet.value == 0) {
        Get.snackbar('Gagal mengirim absen', "Outlet wajib dipilih", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (selectedShift.value == 0) {
        Get.snackbar('Gagal mengirim absen', "Shift wajib dipilih", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }


      Response response = await provider.sendAttendance(
        outletId: selectedOutlet.value,
        shiftId: selectedShift.value,
        latitude: location.latitude,
        longitude: location.longitude,
        namedLocation: namedLocation,
        path: pathFile
      );

      if(response.statusCode == 200) {
        Get.snackbar('Berhasil mengirim absen', response.body['message'], backgroundColor: Colors.green, colorText: Colors.white);
        deletePhoto(pathFile);
        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        Get.snackbar('Gagal mengirim absen', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch(e) {
      print(e);
    } finally {
      sendLoading.value = false;
    }

  }

  Future<void> deletePhoto(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      try {
        await file.delete();
        print('File berhasil dihapus.');
      } catch (e) {
        print('Gagal menghapus file: $e');
      }
    } else {
      print('File tidak ditemukan.');
    }
  }

}
