import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
          child: AppBar(
            title: Obx(
              () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.user['name'], style: Get.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(controller.user['email'], style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                );
              }
            ),
            toolbarHeight: 150,
            backgroundColor: Get.theme.primaryColor,
            foregroundColor: Colors.white,
            
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Get.toNamed(Routes.SALES_REPORT),
                  child: ListTile(
                    title: Text('Laporan Penjualan', style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Get.toNamed(Routes.ATTENDANCE_REPORT),
                  child: ListTile(
                    title: Text('Laporan Absensi', style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Get.toNamed(Routes.DEPOSIT_REPORT),
                  child: ListTile(
                    title: Text('Laporan Setoran', style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Get.toNamed(Routes.SCHEDULE_INFORMATION),
                  child: ListTile(
                    title: Text('Informasi Jadwal', style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
                  child: ListTile(
                    title: Text('Ubah Password', style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () {
                    if(controller.isLoading.value) {
                      return FilledButton(onPressed: null, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
                    } else {
                      return FilledButton(onPressed: () => controller.dialogLogout(), child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout),
                          const SizedBox(width: 10),
                          Text('Logout'),
                        ],
                      ));
                    }
                  }
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
