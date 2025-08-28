import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/login/providers/login_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final LoginProvider provider;
  LoginController(this.provider);
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();

  var hidden_password = true.obs;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

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

  void showPassword() {
    hidden_password.value = !hidden_password.value;
  }

  void login() async {
    if(formKey.currentState!.validate()) {
      buttonLoading.value = true;
      final response = await provider.login(username.text, password.text);
      buttonLoading.value = false;

      if(response.statusCode == 200) {
        box.write('token', response.body['token']);
        box.write('user', response.body['user']);

        if(username.text == password.text) {
          Get.offAllNamed(Routes.MAIN_NAV);
          await Future.delayed(Duration(milliseconds: 200));
          Get.toNamed(Routes.CHANGE_PASSWORD);
        } else {
          Get.offAllNamed(Routes.MAIN_NAV);
        }

      } else {
        if(response.body.containsKey('message')) {
          Get.snackbar('Error login', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar('Error login', 'Tidak ada jaringan internet', backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    }
  }

}
