import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_report_controller.dart';

class AttendanceReportView extends GetView<AttendanceReportController> {
  const AttendanceReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendanceReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AttendanceReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
