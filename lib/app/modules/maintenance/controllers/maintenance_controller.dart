import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/modules/maintenance/providers/maintenance_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/utils/delete_photo.dart';

class MaintenanceController extends GetxController {
  final MaintenanceProvider provider;
  MaintenanceController(this.provider);

  var state = {}.obs;
  var maintenance = [].obs;
  late Map user;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    user = box.read('user');

    fetchMaintenance();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchMaintenance() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getMaintenance(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      // Asumsikan response body list of operator names
      var temps = response.body['data'];
      for(var t in temps) {
        t['isExpanded'] = false;
      }
      maintenance.value = temps;
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  void dialogJob(data) {
    Get.dialog(
        AlertDialog(
          title: Text('Kerjakan'),
          content: Text('Apakah Anda mengerjakan perbaikan ${data['item_name']}'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Tidak', style: TextStyle(color: Colors.red),)),
            FilledButton(onPressed: () => submitMaintenance(data['id']), child: Text('Kerjakan')),
          ],
        )
    );
  }

  Future<void> submitMaintenance(id) async {
    String token = box.read('token');
    Get.dialog(Center(child: CircularProgressIndicator(color: Colors.white)), barrierDismissible: false);
    final response = await provider.submitMaintenance(id, token);
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      await Future.delayed(Duration(milliseconds: 500));
      Get.snackbar('Berhasil', 'Perbaikan berhasil', backgroundColor: Colors.green, colorText: Colors.white);
      fetchMaintenance();
    } else {
      Get.back();
      Get.snackbar('Gagal', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }

  }

  void dialogPicture(data) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // fullscreen
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(), // klik di gambar untuk close
          child: InteractiveViewer(
            child: Image.network(
              "${AppConstants.storageUrl}/${data['request_picture']}",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void bottomSheetApprove(data) {

    var pathPicture = ''.obs;

    Get.bottomSheet(
        Container(
          width: Get.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(20), left: Radius.circular(20))
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gambar Persetujuan', style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                  FilledButton(onPressed: () async {
                    pathPicture.value = await Get.toNamed(Routes.CAMERA_PICKER);
                  }, child: Text('Ambil Gambar'))
                ],),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)
                ),
                child: Obx(
                        () {
                      if(pathPicture.value != '') {
                        return Image.file(File(pathPicture.value));
                      } else {
                        return Image.asset('assets/images/no_data.png', scale: 2);
                      }
                    }
                ),
              ),
              Spacer(),
              SizedBox(
                width: Get.width,
                child: Obx(
                        () {
                      if(pathPicture.value != '') {
                        return FilledButton(onPressed: () {
                          submitMaintenanceApproval(data['id'], pathPicture.value);
                        }, child: Text('Setujui'));
                      } else {
                        return FilledButton(onPressed: null, child: Text('Setujui'));
                      }
                    }
                ),
              )
            ],
          ),
        ),
    ).whenComplete(() {
      DeletePhoto.deletePhoto(pathPicture.value);
    });
  }

  Future<void> submitMaintenanceApproval(id, pathPicture) async {
    String token = box.read('token');
    Get.dialog(Center(child: CircularProgressIndicator(color: Colors.white)), barrierDismissible: false);
    final response = await provider.submitMaintenanceApproval(id, pathPicture, token);
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      await Future.delayed(Duration(milliseconds: 500));
      Get.snackbar('Berhasil', 'Perbaikan berhasil', backgroundColor: Colors.green, colorText: Colors.white);
      await DeletePhoto.deletePhoto(pathPicture);
      fetchMaintenance();
    } else {
      Get.back();
      print(response.body['message']);
      Get.snackbar('Gagal', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
