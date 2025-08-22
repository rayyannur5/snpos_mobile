import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/routes/app_pages.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FilledButton(onPressed: () => Get.toNamed(Routes.LOGIN), child: Text('Lanjutkan')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        height: Get.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Hero(
              tag: 'landing',
              child: Container(
                height: Get.height / 2,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height / 2 - 75,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 155,
                    width: 155,
                    decoration: BoxDecoration(
                      color: Get.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Text('SN POS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 48)),
                  Text('Aplikasi Kasir dan Absensi Karyawan', style: Get.textTheme.labelLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
