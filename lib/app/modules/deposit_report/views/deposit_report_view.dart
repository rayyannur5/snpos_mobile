import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deposit_report_controller.dart';

class DepositReportView extends GetView<DepositReportController> {
  const DepositReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepositReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DepositReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
