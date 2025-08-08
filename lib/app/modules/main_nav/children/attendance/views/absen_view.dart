import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/controllers/attendance_controller.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/utils/currency_formatter.dart';
import 'package:snpos/app/widgets/attendance_item_widget.dart';

class AbsenView extends GetView<AttendanceController> {
  const AbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshPage,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/absen.png', scale: 2),
                SizedBox(height: 20),
                Text('Semangat Bekerja !!', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: FilledButton(onPressed: () => Get.toNamed(Routes.ATTENDANCE_CAMERA), child: Text('Absen Keluar')),
                )
              ],
            ),

            const SizedBox(height: 20),
            AttendanceItemWidget(dateIn: DateTime.now(), dateOut: DateTime.now(), isDeposit: true, isLate: false, outlet: 'Tanggulangin',omset: 600000,shift: 'Shift 1',)
          ],
        ),
      ),
    );
  }
}
