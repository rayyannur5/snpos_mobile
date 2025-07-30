import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
            Container(
              height: Get.height / 4,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            Positioned(
              top: Get.height / 4 - 75,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: Get.width,
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
                    TextField(decoration: InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email))),
                    SizedBox(height: 20),
                    TextField(obscureText: true,decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.password))),
                    SizedBox(height: 30),
                    SizedBox(width: Get.width, child: FilledButton(onPressed: ()=>Get.offAllNamed(Routes.MAIN_NAV), child: Text('Login')))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
