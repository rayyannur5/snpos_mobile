import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/attendance_view.dart';
import 'package:snpos/app/modules/main_nav/children/home/views/home_view.dart';
import 'package:snpos/app/modules/main_nav/children/profile/views/profile_view.dart';
import 'package:snpos/app/routes/app_pages.dart';

import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx( () {
        return Scaffold(

          body: IndexedStack(
            index: controller.currentIndex.value,
            children: controller.menus,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => controller.changeTab(1), // tengah = Absensi
            shape: CircleBorder(),
            backgroundColor: Colors.indigo[900],
            elevation: 4,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 15,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: controller.currentIndex.value == 0
                          ? Colors.indigo[900]
                          : Get.theme.disabledColor,
                    ),
                    onPressed: () => controller.changeTab(0),
                  ),
                  const SizedBox(width: 40), // ruang untuk FAB
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: controller.currentIndex.value == 2
                          ? Colors.indigo[900]
                          : Get.theme.disabledColor,
                    ),
                    onPressed: () => controller.changeTab(2),
                  ),
                ],
              ),
            ),
          ),
        );

      }
    );
  }
}
