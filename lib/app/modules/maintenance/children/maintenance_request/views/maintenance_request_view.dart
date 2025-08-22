import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/maintenance_request_controller.dart';

class MaintenanceRequestView extends GetView<MaintenanceRequestController> {
  const MaintenanceRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: AppBar(title: Text('Request Perbaikan'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(width: Get.width, child: Obx(
                () {
              if(controller.loadingButton.value) {
                return FilledButton(onPressed: null, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(),));
              } else {
                return FilledButton(onPressed: () {
                  FocusScope.of(context).unfocus();
                  controller.submitMaintenanceRequest();
                }, child: Text('Request Perbaikan'));
              }
            }
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: controller.fetchMaintenanceRequest,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            if (controller.state['loading']) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.state['error']) {
              return ListView(
                children: [NoInternetWidget(onClickRefresh: () => controller.fetchMaintenanceRequest(), errorMessage: controller.state['message'])],
              );
            }
            return ListView(
              children: [
                Text('Pilih Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: controller.selectedItem.value,
                  hint: Text('Pilih Barang'),
                  isExpanded: true,
                  items:
                      controller.items.map((item) {
                        return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                      }).toList(),
                  onChanged: (value) {
                    print(value);
                    controller.selectedItem.value = value as int?;
                  },
                ),
                SizedBox(height: 20),
                Text('Pilih Outlet', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: controller.selectedOutlet.value,
                  hint: Text('Pilih Outlet'),
                  isExpanded: true,
                  items:
                      controller.outlets.map((item) {
                        return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                      }).toList(),
                  onChanged: (value) {
                    print(value);
                    controller.selectedOutlet.value = value as int?;
                  },
                ),
                SizedBox(height: 20),
                // 4. Catatan
                Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: controller.noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    hintText: 'Masukkan catatan jika ada',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Foto', style: TextStyle(fontWeight: FontWeight.bold)),
                    FilledButton(onPressed: () {
                      Get.toNamed(Routes.CAMERA_PICKER)?.then((value) {
                        if (value != null) {
                          controller.image.value = value;
                        }
                      });
                    }, child: Text('Ambil Foto'))
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(
                    () {
                      if(controller.image.value != null) {
                        return Image.file(File(controller.image.value!));
                      } else {
                        return Image.asset('assets/images/no_data.png');
                      }
                    }
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
