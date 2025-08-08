import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: AppBar(title: Text('Ubah Password'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextField(enabled: false, controller: TextEditingController(text: 'Rayyan Nur Fauzan'), decoration: InputDecoration(labelText: 'Nama')),
              const SizedBox(height: 20),
              TextField(enabled: false, controller: TextEditingController(text: 'rayyannur5'), decoration: InputDecoration(labelText: 'Username')),
              const SizedBox(height: 20),
              TextField(enabled: false, controller: TextEditingController(text: 'rayyannur5@gmail.com'), decoration: InputDecoration(labelText: 'Email address')),
              const SizedBox(height: 20),
              Obx(() {
                return TextFormField(
                  controller: controller.old_password,
                  obscureText: controller.hidden_password_old.value,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    suffixIcon: IconButton(
                      onPressed: controller.showPasswordOld,
                      icon: Icon(controller.hidden_password_old.value ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password lama wajib diisi';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                return TextFormField(
                  controller: controller.new_password,
                  obscureText: controller.hidden_password_new.value,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    suffixIcon: IconButton(
                      onPressed: controller.showPasswordNew,
                      icon: Icon(controller.hidden_password_old.value ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password baru wajib diisi';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                return TextFormField(
                  controller: controller.new_password_2,
                  obscureText: controller.hidden_password_new_2.value,
                  decoration: InputDecoration(
                    labelText: 'Ketik Ulang Password Baru',
                    suffixIcon: IconButton(
                      onPressed: controller.showPasswordNew2,
                      icon: Icon(controller.hidden_password_new_2.value ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value != controller.new_password.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                );
              }),
              Spacer(),
              Obx(() {
                if(controller.buttonLoading.value) {
                  return SizedBox(width: Get.width, child: FilledButton(onPressed: null, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(),)));
                } else {
                  return SizedBox(width: Get.width, child: FilledButton(onPressed: controller.save, child: Text('Simpan')));
                }
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
