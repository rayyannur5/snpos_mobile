import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/absen_view.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/after_absen_view.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/before_absen_view.dart';

import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi', style: Get.textTheme.headlineLarge),
        toolbarHeight: 80,
      ),
      body: Obx(
        () {
          if(controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if(controller.absenStatus.value == AbsenStatus.IsAbsen) {
            return AbsenView();
          } else if (controller.absenStatus.value == AbsenStatus.IsNotAbsen) {
            return BeforeAbsenView();
          } else {
            return AfterAbsenView();
          }
        }
      ),
    );
  }
}
