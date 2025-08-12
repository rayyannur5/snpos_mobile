import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class CreateDepositController extends GetxController {
  final AttendanceProvider provider;
  CreateDepositController(this.provider);

  final box = GetStorage();

  var response = {}.obs;
  var isLoading = true.obs;
  var buttonLoading = false.obs;

  final TextEditingController remarkController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTransactionNotDepositYet();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchTransactionNotDepositYet() async {
    isLoading.value = true;
    String token = box.read('token');
    Response res = await provider.getTransactionNotDepositYet(token);
    print(res.body);
    if(res.statusCode == 200) {
      response.value = res.body['data'] ?? {};
      print(response.value);
    } else {
      Get.snackbar('Error fetch transaction data', '${res.body.message}', backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> deposit() async {
    buttonLoading.value = true;
    String token = box.read('token');

    String remarks = remarkController.text;

    Response res = await provider.deposit(token, remarks);
    if(res.statusCode == 200) {
      Get.snackbar('Berhasil Membuat Setoran', '', backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed(Routes.MAIN_NAV);
    } else {
      Get.snackbar('Error fetch shifts', '${res.body.message}', backgroundColor: Colors.red, colorText: Colors.white);
    }
    buttonLoading.value = false;
  }

}
