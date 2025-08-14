import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  final ProfileProvider provider;
  ProfileController(this.provider);

  var isLoading = false.obs;

  var token = ''.obs;
  var user = {}.obs;

  @override
  void onInit() {
    final storedToken = box.read('token');
    if (storedToken != null) {
      token.value = storedToken;
      user.value = box.read('user');
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void dialogLogout()  {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Tidak')),
          TextButton(onPressed: () => logout(), child: Text('Ya')),
        ],
      )
    );
  }

  Future<void> logout() async {

    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    var response = await provider.logout(token.value);
    if(response.statusCode == 200) {
      box.remove('token');
      Get.snackbar('Berhasil Logout', '', backgroundColor: Colors.green, colorText: Colors.white);
      await Future.delayed(Duration(milliseconds: 100));
      Get.offAllNamed(Routes.LANDING);
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      Get.back();
      Get.snackbar('Gagal Logout', response.body != null ? response.body['message'] : 'No Internet', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
