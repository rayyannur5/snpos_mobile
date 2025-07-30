import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sales_report_controller.dart';

class SalesReportView extends GetView<SalesReportController> {
  const SalesReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SalesReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SalesReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
