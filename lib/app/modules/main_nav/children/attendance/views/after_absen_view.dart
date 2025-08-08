import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/controllers/attendance_controller.dart';
import 'package:snpos/app/routes/app_pages.dart';

class AfterAbsenView extends GetView<AttendanceController> {
  const AfterAbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshPage,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/after_absen.png', scale: 2),
                SizedBox(height: 20),
                Text('Terimakasih Sudah Bekerja dengan Baik', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: FilledButton(onPressed: () => Get.toNamed(Routes.CREATE_DEPOSIT), child: Text('Buat Laporan')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
