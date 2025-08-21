import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/maintenance_approval_controller.dart';

class MaintenanceApprovalView extends GetView<MaintenanceApprovalController> {
  const MaintenanceApprovalView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(tag: 'appbar', child: AppBar(title: Text('Setujui Perbaikan'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white)),
        ),
      ),
      body: const Center(
        child: Text(
          'MaintenanceApprovalView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
