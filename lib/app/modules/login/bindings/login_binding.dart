import 'package:get/get.dart';
import 'package:snpos/app/modules/login/providers/login_provider.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginProvider>(()=> LoginProvider());
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find()),
    );
  }
}
