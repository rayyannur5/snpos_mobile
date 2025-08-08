import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/home/controllers/home_controller.dart';
import 'package:snpos/app/modules/main_nav/controllers/main_nav_controller.dart';

class NotAbsenYetView extends GetView<HomeController> {
  const NotAbsenYetView({super.key});

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
                Image.asset('assets/images/belum-absen.png', scale: 2),
                SizedBox(height: 20),
                Text('Absen Dulu yaa...', style: Get.textTheme.headlineMedium),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: FilledButton(onPressed: () {
                    Get.find<MainNavController>().changeTab(1);
                  }, child: Text('Absensi')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
