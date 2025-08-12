import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';

class AttendanceController extends GetxController {
  final AttendanceProvider provider;
  AttendanceController(this.provider);

  var absenStatus = AbsenStatus.IsNotAbsen.obs;
  var isLoading = false.obs;
  var attendanceToday = [].obs;
  var attendanceLoading = false.obs;
  var canDeposit = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    refreshPage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> refreshPage() async {
    isLoading.value = true;
    var response = await provider.updateUserData(box.read('token'));

    if(response.statusCode == 200) {
      var user = response.body['data'];
      box.write('user', user);

      if (user['is_absen'] == 'Y') {
        absenStatus.value = AbsenStatus.IsAbsen;

        attendanceLoading.value = true;
        var attendance = await provider.getAttendanceToday(token: box.read('token'));
        attendanceLoading.value = false;
        if(attendance.statusCode == 200) {
          attendanceToday.value = attendance.body['data'];
        } else {
          print('attendance_controller ${attendance.body['message']}');
          Get.snackbar('Error', attendance.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
        }

      } else if (user['is_absen'] == 'N') {
        absenStatus.value = AbsenStatus.IsNotAbsen;
      } else if (user['is_absen'] == 'X') {
        canDeposit.value = await checkCanDeposit();
        absenStatus.value = AbsenStatus.AfterAbsen;
      }
    }

    isLoading.value = false;

  }


  Future<bool> checkCanDeposit() async {
    String token = box.read('token');

    var response = await provider.getTransactionNotDepositYet(token);
    if(response.statusCode == 200) {
      return int.parse(response.body['data']['total_amount'] ?? '0') > 0;
    } else {
      return false;
    }

  }

}
