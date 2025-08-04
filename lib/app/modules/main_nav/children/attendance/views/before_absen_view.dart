import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/controllers/attendance_controller.dart';
import 'package:snpos/app/routes/app_pages.dart';

class BeforeAbsenView extends GetView<AttendanceController> {
  const BeforeAbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchAbsenStatus(),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/before_absen.png', scale: 2),
                SizedBox(height: 20),
                Text('Selamat Datang Silakan Melakukan Absensi', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: FilledButton(onPressed: () => Get.toNamed(Routes.ATTENDANCE_CAMERA), child: Text('Absen Masuk')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
