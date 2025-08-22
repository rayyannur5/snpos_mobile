import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            Hero(
              tag: 'landing',
              child: Container(
                height: Get.height / 4,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height / 4 - 75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: Get.width,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          height: 155,
                          width: 155,
                          decoration: BoxDecoration(
                            color: Get.theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Selamat Datang, 👋', style: Get.textTheme.headlineMedium),
                      Text('Silahkan Login untuk melanjutkan', style: Get.textTheme.labelLarge),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: controller.username,
                        decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.email)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return TextFormField(
                          controller: controller.password,
                          obscureText: controller.hidden_password.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: controller.showPassword,
                              icon: Icon(controller.hidden_password.value ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password wajib diisi';
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(height: 30),
                      SizedBox(width: Get.width, child: Obx(
                        () {
                          if(controller.buttonLoading.value) {
                            return FilledButton(onPressed: null, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(),));
                          } else {
                            return FilledButton(onPressed: controller.login, child: Text('Login'));
                          }
                        }
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
