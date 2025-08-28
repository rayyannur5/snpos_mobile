import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:snpos/app/widgets/user_card_widget.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      body: Obx(() {
        if (controller.absenStatus.value == AbsenStatus.AfterAbsen) {
          return const SizedBox();
        } else if (controller.absenStatus.value == AbsenStatus.IsNotAbsen) {
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
                        child: FilledButton(
                          onPressed: () {
                            Get.find<MainNavController>().changeTab(1);
                          },
                          child: Text('Absensi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Hero(
                  tag: 'appbar',
                  child: UserCardWidget(
                    name: controller.user['name'],
                    position: controller.user['level_name'],
                    checkIn: DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(controller.user['check_in_time'])),
                    location: controller.user['outlet_name'],
                    status: controller.user['is_late'] == 1 ? 'Terlambat' : 'Tepat Waktu',
                    shift: controller.user['shift_name'],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshPage,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                      children:
                          controller.menus.map((menu) {
                            return Card(
                              color: menu['color'],
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () => Get.toNamed(menu['route']),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white.withOpacity(0.6),
                                      child: Icon(menu['icon'], size: 32, color: menu['iconColor']),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      menu['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
