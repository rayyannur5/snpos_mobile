import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController(this.provider);
  final ProfileProvider provider;

  var hidden_password_old = true.obs;
  var hidden_password_new = true.obs;
  var hidden_password_new_2 = true.obs;

  final TextEditingController old_password = TextEditingController();
  final TextEditingController new_password = TextEditingController();
  final TextEditingController new_password_2 = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var buttonLoading = false.obs;

  @override
  void onInit() {
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

  void showPasswordOld() {
    hidden_password_old.value = !hidden_password_old.value;
  }

  void showPasswordNew() {
    hidden_password_new.value = !hidden_password_new.value;
  }

  void showPasswordNew2() {
    hidden_password_new_2.value = !hidden_password_new_2.value;
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      // semua validasi lolos
      print("Password lama: ${old_password.text}");
      print("Password baru: ${new_password.text}");
      print("Konfirmasi password baru: ${new_password_2.text}");

      buttonLoading.value = true;

      var response = await provider.changePassword(old_password.text, new_password.text);
      if(response.statusCode == 200) {
        Get.snackbar('Berhasil ubah password', '', backgroundColor: Colors.green, colorText: Colors.white);
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAllNamed(Routes.MAIN_NAV);
      } else {
        Get.snackbar('Error change password', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
      }

      buttonLoading.value = false;

    } else {
      print("Form tidak valid");
    }
  }

}
