import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
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
                SizedBox(width: Get.width, child: FilledButton(onPressed: () => Get.toNamed(Routes.ATTENDANCE_CAMERA), child: Text('Absen Keluar'))),
              ],
            ),

            const SizedBox(height: 20),
            Obx(() {
              if (controller.attendanceLoading.value) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Shimmer(
                    color: Colors.white,
                    child: Container(height: 100, decoration: BoxDecoration(color: Color(0xDFDDDDDD), borderRadius: BorderRadius.circular(15)))),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      controller.attendanceToday
                          .map(
                            (e) => AttendanceItemWidget(
                              id: e['id'].toString(),
                              dateIn: DateTime.parse(e['check_in_time']),
                              dateOut: e['check_out_time'] == null ? null : DateTime.parse(e['check_out_time']),
                              isDeposit: e['is_deposit'] == 1 ? true : false,
                              isLate: e['is_late'] == 1 ? true : false,
                              outlet: e['outlet_name'],
                              omset: int.tryParse(e['omset'] ?? '0') ?? 0,
                              shift: e['shift_name'],
                            ),
                          )
                          .toList(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
