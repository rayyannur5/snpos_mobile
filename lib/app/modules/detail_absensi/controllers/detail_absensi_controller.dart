import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/detail_absensi/providers/detail_absensi_provider.dart';

class DetailAbsensiController extends GetxController {
  final DetailAbsensiProvider provider;
  DetailAbsensiController(this.provider);

  late String id;
  final box = GetStorage();

  var response = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map;
    id = args['id'];

    detailAttendance(id);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> detailAttendance(id) async {
    isLoading.value = true;
    String token = box.read('token');
    Response res = await provider.detailAttendance(token, id);
    if(res.statusCode == 200) {
      response.value = res.body['data'] ?? {};
    } else {
      if(res.body.containsKey('message')) {
        Get.snackbar('Error fetch transaction data', '${res.body.message}', backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Error fetch transaction data', 'Tidak ada jaringan internet', backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    isLoading.value = false;
  }
}
