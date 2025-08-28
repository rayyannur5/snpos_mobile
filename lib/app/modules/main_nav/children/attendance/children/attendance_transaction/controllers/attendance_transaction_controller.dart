import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class AttendanceTransactionController extends GetxController {
  final AttendanceProvider provider;
  AttendanceTransactionController(this.provider);

  final box = GetStorage();

  late final Position location;
  late final String pathFile;
  late final String namedLocation;

  var sendLoading = false.obs;

  var schedule = Rxn<Map<String, dynamic>>();
  var loadingSchedule = false.obs;

  var outlets = [].obs;
  var selectedOutlet = RxnInt();
  var shifts = [].obs;
  var selectedShift = RxnInt();

  var inRadius = false.obs;

  var isExitAbsen = false.obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();

    user.value = box.read('user');
    if(user['is_absen'] != 'Y') {
      if([6,7].contains(user['level'])) {
        fetchSchedule();
      } else {
        fetchOutlets();
      }
    }

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

  void sendAttendance() async {
    sendLoading.value = true;
    try{
      String token = box.read('token');

      Response response = await provider.sendAttendance(
        scheduleId: schedule.value?['id'],
        latitude: location.latitude,
        longitude: location.longitude,
        namedLocation: namedLocation,
        path: pathFile,
        token: token,
        outletId: selectedOutlet.value,
        shiftId: selectedShift.value,
      );

      if(response.statusCode == 200) {
        box.write('user', response.body['data']);
        Get.snackbar('Berhasil mengirim absen', response.body['message'], backgroundColor: Colors.green, colorText: Colors.white);
        deletePhoto(pathFile);
        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        Get.snackbar('Gagal mengirim absen', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch(e) {
      print(e);
      Get.snackbar('Gagal mengirim absen', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      sendLoading.value = false;
    }

  }

  void sendExitAttendance() async {
    sendLoading.value = true;
    try{
      String token = box.read('token');

      Response response = await provider.sendExitAttendance(
        attendanceId: user['attendance_id'],
        latitude: location.latitude,
        longitude: location.longitude,
        namedLocation: namedLocation,
        path: pathFile,
        token: token,
      );

      if(response.statusCode == 200) {
        box.write('user', response.body['data']);
        Get.snackbar('Berhasil mengirim absen', response.body['message'], backgroundColor: Colors.green, colorText: Colors.white);
        deletePhoto(pathFile);
        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        Get.snackbar('Gagal mengirim absen', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch(e) {
      print(e);
      Get.snackbar('Gagal mengirim absen', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
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

  Future<void> fetchSchedule() async {
    loadingSchedule.value = true;
    String token = box.read('token');
    var response = await provider.fetchSchedule(token);
    loadingSchedule.value = false;
    if(response.statusCode == 200) {
      schedule.value = response.body['data'];

      if(schedule.value != null) {
        var distance = Geolocator.distanceBetween(location.latitude, location.longitude, schedule.value?['latitude'], schedule.value?['longitude']);

        print("distance : $distance");

        if (distance > (schedule.value!['allowance_radius'] * 1000)) {
          Get.snackbar('Diluar Radius', 'Ambil absen lagi di dekat outlet yang sudah ditetapkan', backgroundColor: Colors.red, colorText: Colors.white);
          inRadius.value = false;
        } else {
          inRadius.value = true;
        }
      }



    } else {
      Get.snackbar('Gagal mengambil jadwal', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchOutlets() async {
    loadingSchedule.value = true;
    String token = box.read('token');
    var response = await provider.fetchOutlets(token);
    loadingSchedule.value = false;
    if(response.statusCode == 200) {
      print(response.body);
      outlets.value = response.body['data']['outlets'];
      shifts.value = response.body['data']['shifts'];
    } else {
      Get.snackbar('Gagal mengambil jadwal', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> refreshPage() async {
    if(user['is_absen'] != 'Y') {
      fetchSchedule();
    }
  }

}
